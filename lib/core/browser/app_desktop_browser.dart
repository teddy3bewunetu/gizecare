import 'dart:async';
import 'dart:io';
import 'dart:ui' show Offset, PlatformDispatcher, Size;

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:gizecare/core/browser/browser_injected_scripts.dart';
import 'package:gizecare/core/constants/app_constants.dart';
import 'package:gizecare/core/platform/app_platform.dart';

/// Callbacks from the desktop WebKit/WebView2 engine into Flutter chrome.
typedef BrowserUrlCallback = void Function(String tabId, String url);
typedef BrowserHistoryCallback = void Function(
  String tabId, {
  required bool canGoBack,
  required bool canGoForward,
});
typedef BrowserNavigatingCallback = void Function(
  String tabId,
  bool isNavigating,
);

/// In-memory snapshot of a Flutter tab strip entry for a desktop feature.
class DesktopBrowserTabSnapshot {
  const DesktopBrowserTabSnapshot({
    required this.id,
    required this.url,
    required this.title,
  });

  final String id;
  final String url;
  final String title;
}

/// Desktop browser engine — one companion WebKit/WebView2 window per session.
///
/// Apps (ChatGPT / Gemini / YouTube / WhatsApp) use stable [sessionKey]s so
/// switching routes reuses the warm WebKit process, cookies, and history
/// instead of creating a new window every time.
abstract final class AppDesktopBrowser {
  static final Map<String, Webview> _tabs = {};
  static final Map<String, String> _sessionUrls = {};
  static final Map<String, List<DesktopBrowserTabSnapshot>> _featureTabStrips =
      {};
  static final Map<String, String> _featureActiveTabIds = {};
  static String? _activeTabId;
  /// When > 0, [show] / [activateTab] must not map companion windows — Flutter
  /// dialogs/menus sit under the native WebKit surface otherwise.
  static int _overlayLocks = 0;
  /// Serializes create/activate so rapid feature switches never drop opens.
  static Future<void> _openChain = Future<void>.value();
  static const _uuid = Uuid();

  static BrowserUrlCallback? onUrlChanged;
  static BrowserHistoryCallback? onHistoryChanged;
  static BrowserNavigatingCallback? onNavigating;

  /// Fired when native intercepts a YouTube watch URL (WebKit media is unsafe).
  static BrowserUrlCallback? onInAppMedia;

  static bool get isAvailable =>
      AppPlatform.isDesktop &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.windows);

  static bool get hasSession => _tabs.isNotEmpty;

  static String? get activeTabId => _activeTabId;

  static bool get overlayLocked => _overlayLocks > 0;

  /// Hide every companion window and keep them hidden until matching
  /// [endOverlay]. Nested (menu → dialog) is supported via a counter.
  static Future<void> beginOverlay() async {
    _overlayLocks++;
    await hide();
  }

  static Future<void> endOverlay({bool restore = true}) async {
    if (_overlayLocks > 0) _overlayLocks--;
    if (_overlayLocks == 0 && restore) {
      await show();
    }
  }

  static String? urlForSession(String sessionKey) => _sessionUrls[sessionKey];

  static String newTabId() => _uuid.v4();

  /// Routes that host a companion WebKit/WebView2 window.
  static bool isCompanionPath(String path) {
    const roots = <String>[
      '/browser',
      '/apps/chatgpt',
      '/apps/gemini',
      '/apps/youtube',
      '/messages/whatsapp',
    ];
    for (final root in roots) {
      if (path == root || path.startsWith('$root/')) return true;
    }
    return false;
  }

  /// Hides every companion window when [path] is not a browser feature.
  /// Call from the shell on every route change so Home/Notes never leave a
  /// floating WebKit window behind (hot reload / failed dispose / races).
  static Future<void> syncToRoute(String path) async {
    if (!isAvailable) return;
    if (!isCompanionPath(path)) {
      await hide();
    }
  }

  /// Last known Flutter tab strip for a feature (e.g. `app:whatsapp`).
  static List<DesktopBrowserTabSnapshot>? featureTabStrip(String featureKey) {
    final strip = _featureTabStrips[featureKey];
    if (strip == null || strip.isEmpty) return null;
    return List<DesktopBrowserTabSnapshot>.unmodifiable(strip);
  }

  static String? featureActiveTabId(String featureKey) =>
      _featureActiveTabIds[featureKey];

  /// Persists the Flutter tab strip so leaving Documents/Projects and returning
  /// restores the same tabs/windows for that feature.
  static void saveFeatureTabStrip(
    String featureKey,
    List<DesktopBrowserTabSnapshot> tabs, {
    required String activeTabId,
  }) {
    if (featureKey.isEmpty || tabs.isEmpty) return;
    _featureTabStrips[featureKey] = List<DesktopBrowserTabSnapshot>.from(tabs);
    _featureActiveTabIds[featureKey] = activeTabId;
  }

  static void clearFeatureTabStrip(String featureKey) {
    _featureTabStrips.remove(featureKey);
    _featureActiveTabIds.remove(featureKey);
  }

  /// Stable session id for an app / site (e.g. `host:www.youtube.com`).
  static String sessionKeyForUrl(String url) {
    final uri = Uri.tryParse(url);
    final host = uri?.host.toLowerCase() ?? '';
    if (host.isEmpty) return 'tab:${newTabId()}';
    return 'host:$host';
  }

  /// Opens or resumes a session. Warm sessions are only navigated when
  /// [forceNavigate] is true (address-bar submit / explicit open).
  ///
  /// Calls are serialized — rapid YouTube→WhatsApp→ChatGPT switches wait
  /// their turn instead of returning false while another open is in flight.
  static Future<bool> openSession(
    String sessionKey,
    String url, {
    bool forceNavigate = false,
    bool activate = true,
  }) {
    if (!isAvailable) return Future.value(false);
    late final Future<bool> result;
    result = _openChain.then(
      (_) => _openSessionBody(
        sessionKey,
        url,
        forceNavigate: forceNavigate,
        activate: activate,
      ),
    );
    // Keep the gate advancing even when a create/activate fails.
    _openChain = result.then((_) {}, onError: (_) {});
    return result;
  }

  static Future<bool> _openSessionBody(
    String sessionKey,
    String url, {
    required bool forceNavigate,
    required bool activate,
  }) async {
    try {
      if (!await WebviewWindow.isWebviewAvailable()) {
        return _launchExternal(url);
      }

      final existing = _tabs[sessionKey];
      if (existing != null) {
        _wire(sessionKey, existing);
        if (forceNavigate) {
          existing.launch(url);
          _sessionUrls[sessionKey] = url;
        }
        if (activate) {
          await activateTab(sessionKey);
        }
        final known = _sessionUrls[sessionKey] ?? url;
        onUrlChanged?.call(sessionKey, known);
        return true;
      }

      final dataDir = await userDataDir();
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: '${AppConstants.appName} Browser',
          titleBarHeight: 0,
          windowWidth: 960,
          windowHeight: 640,
          userDataFolderWindows: dataDir,
        ),
      );
      _tabs[sessionKey] = webview;
      _sessionUrls[sessionKey] = url;
      _wire(sessionKey, webview);

      try {
        await webview.setApplicationNameForUserAgent(' ${AppConstants.appName}');
      } catch (_) {}

      try {
        webview.addScriptToExecuteOnDocumentCreated(
          BrowserInjectedScripts.sameWindowNavigation,
        );
        webview.addScriptToExecuteOnDocumentCreated(
          BrowserInjectedScripts.ctrlEnterNewline,
        );
      } catch (e) {
        debugPrint('AppDesktopBrowser inject shortcuts: $e');
      }

      webview.launch(url);
      // Publish the intended URL immediately so Flutter chrome doesn't keep
      // showing the previous tab's address while WebKit boots.
      onUrlChanged?.call(sessionKey, url);
      unawaited(
        webview.onClose.then((_) {
          _tabs.remove(sessionKey);
          _sessionUrls.remove(sessionKey);
          _removeTabFromFeatureStrips(sessionKey);
          if (_activeTabId == sessionKey) {
            _activeTabId = _tabs.keys.isEmpty ? null : _tabs.keys.first;
          }
        }),
      );
      if (activate) {
        await activateTab(sessionKey);
      } else {
        try {
          await webview.setWebviewWindowVisibility(false);
        } catch (_) {}
      }
      return true;
    } catch (e, st) {
      debugPrint('AppDesktopBrowser.openSession failed: $e\n$st');
      _tabs.remove(sessionKey);
      _sessionUrls.remove(sessionKey);
      return _launchExternal(url);
    }
  }

  /// Creates (or reuses) a content window for [tabId] and loads [url].
  static Future<bool> openTab(
    String tabId,
    String url, {
    bool activate = true,
  }) =>
      openSession(tabId, url, forceNavigate: true, activate: activate);

  /// Shows [tabId] and hides every other tab window.
  static Future<void> activateTab(String tabId) async {
    if (!_tabs.containsKey(tabId)) return;
    _activeTabId = tabId;
    for (final entry in _tabs.entries) {
      final visible = entry.key == tabId && !overlayLocked;
      try {
        await entry.value.setWebviewWindowVisibility(visible);
      } catch (e) {
        debugPrint('AppDesktopBrowser.activateTab visibility: $e');
      }
    }
  }

  /// Hides one session without destroying its WebKit process / history.
  static Future<void> hideSession(String sessionKey) async {
    final w = _tabs[sessionKey];
    if (w == null) return;
    try {
      await w.setWebviewWindowVisibility(false);
    } catch (e) {
      debugPrint('AppDesktopBrowser.hideSession: $e');
    }
    if (_activeTabId == sessionKey) {
      _activeTabId = null;
    }
  }

  /// Hides every window belonging to a feature's saved tab strip (primary +
  /// extra tabs). Falls back to hiding [featureKey] alone when no strip.
  static Future<void> hideFeature(String featureKey) async {
    final strip = _featureTabStrips[featureKey];
    final ids = <String>{
      featureKey,
      if (strip != null) ...strip.map((t) => t.id),
    };
    for (final id in ids) {
      await hideSession(id);
    }
  }

  static Future<void> closeTab(String tabId) async {
    final w = _tabs.remove(tabId);
    _sessionUrls.remove(tabId);
    _removeTabFromFeatureStrips(tabId);
    if (_activeTabId == tabId) {
      _activeTabId = _tabs.keys.isEmpty ? null : _tabs.keys.first;
    }
    try {
      w?.close();
    } catch (_) {}
    if (_activeTabId != null) {
      await activateTab(_activeTabId!);
    }
  }

  static void _removeTabFromFeatureStrips(String tabId) {
    for (final entry in _featureTabStrips.entries.toList()) {
      final next = entry.value.where((t) => t.id != tabId).toList();
      if (next.length == entry.value.length) continue;
      if (next.isEmpty) {
        _featureTabStrips.remove(entry.key);
        _featureActiveTabIds.remove(entry.key);
      } else {
        _featureTabStrips[entry.key] = next;
        if (_featureActiveTabIds[entry.key] == tabId) {
          _featureActiveTabIds[entry.key] = next.first.id;
        }
      }
    }
  }

  static void _wire(String tabId, Webview webview) {
    WebviewWindow.onExternalUrlHandOff ??= (url) async {
      onInAppMedia?.call(_activeTabId ?? tabId, url);
    };
    webview.setOnUrlRequestCallback((url) {
      if (url == 'about:blank' || url.trim().isEmpty) return true;
      if (_isYoutubeWatchUrl(url)) {
        onInAppMedia?.call(tabId, url);
        return false;
      }
      // Google account / One Tap widgets often navigate the top frame to
      // ogs.google.com — allow the request but don't overwrite the omnibox.
      if (!_isTransientGoogleChromeUrl(url)) {
        _sessionUrls[tabId] = url;
        onUrlChanged?.call(tabId, url);
      }
      return true;
    });
    webview.setOnHistoryChangedCallback((canGoBack, canGoForward) {
      onHistoryChanged?.call(
        tabId,
        canGoBack: canGoBack,
        canGoForward: canGoForward,
      );
    });
    webview.isNavigating.addListener(() {
      onNavigating?.call(tabId, webview.isNavigating.value);
    });
  }

  static bool _isYoutubeWatchUrl(String url) {
    final u = url.toLowerCase();
    return u.contains('youtube.com/watch') ||
        u.contains('youtube.com/shorts/') ||
        u.contains('youtube.com/embed/') ||
        u.contains('youtube.com/live/') ||
        u.contains('youtu.be/') ||
        u.contains('youtube-nocookie.com/');
  }

  /// Account chooser / app-launcher widgets that briefly take over the main frame.
  static bool _isTransientGoogleChromeUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    if (host == 'ogs.google.com') return true;
    if (host == 'accounts.google.com') {
      final path = uri.path.toLowerCase();
      return path.contains('accountchooser') ||
          path.contains('signin') ||
          path.contains('servicelogin') ||
          path.contains('o/oauth2');
    }
    return false;
  }

  static Future<void> navigate(String url) async {
    final id = _activeTabId;
    if (id == null) {
      // Never bind omnibox navigations to host:* app sessions — always a fresh tab id.
      await openSession(newTabId(), url, forceNavigate: true);
      return;
    }
    _sessionUrls[id] = url;
    _tabs[id]?.launch(url);
    onUrlChanged?.call(id, url);
  }

  static Future<void> goBack() async => _tabs[_activeTabId]?.back();

  static Future<void> goForward() async => _tabs[_activeTabId]?.forward();

  static Future<void> reload() async => _tabs[_activeTabId]?.reload();

  static Future<void> stop() async => _tabs[_activeTabId]?.stop();

  static Future<void> openDevTools() async {
    final w = _tabs[_activeTabId];
    if (w == null) return;
    try {
      await w.openDevToolsWindow();
    } catch (e) {
      debugPrint('AppDesktopBrowser.openDevTools: $e');
    }
  }

  static Future<void> show() async {
    if (overlayLocked) return;
    final id = _activeTabId;
    if (id == null) return;
    try {
      await _tabs[id]?.setWebviewWindowVisibility(true);
    } catch (e) {
      debugPrint('AppDesktopBrowser.show: $e');
    }
  }

  static Future<void> hide() async {
    for (final w in _tabs.values) {
      try {
        await w.setWebviewWindowVisibility(false);
      } catch (e) {
        debugPrint('AppDesktopBrowser.hide: $e');
      }
    }
  }

  /// Docks the active tab window into the Browser content placeholder.
  static Future<void> dockTo(Offset viewRelativeTopLeft, Size size) async {
    final w = _tabs[_activeTabId];
    if (w == null || size.width < 32 || size.height < 32) return;

    late final int left;
    late final int top;
    late final int width;
    late final int height;

    if (Platform.isWindows) {
      final dpr = PlatformDispatcher.instance.views.isEmpty
          ? 1.0
          : PlatformDispatcher.instance.views.first.devicePixelRatio;
      left = (viewRelativeTopLeft.dx * dpr).round();
      top = (viewRelativeTopLeft.dy * dpr).round();
      width = (size.width * dpr).round();
      height = (size.height * dpr).round();
    } else {
      left = viewRelativeTopLeft.dx.round();
      top = viewRelativeTopLeft.dy.round();
      width = size.width.round();
      height = size.height.round();
    }

    try {
      await w.moveWebviewWindow(left, top, width, height);
    } catch (e) {
      debugPrint('AppDesktopBrowser.dockTo: $e');
    }
  }

  static Future<void> closeAll() async {
    final all = List<Webview>.from(_tabs.values);
    _tabs.clear();
    _sessionUrls.clear();
    _featureTabStrips.clear();
    _featureActiveTabIds.clear();
    _activeTabId = null;
    for (final w in all) {
      try {
        w.close();
      } catch (_) {}
    }
  }

  /// Back-compat: open/replace a single session tab.
  static Future<bool> ensureOpen(String url) async {
    return openSession(sessionKeyForUrl(url), url, forceNavigate: true);
  }

  static Future<void> close() => closeAll();

  static Future<String> userDataDir() async {
    final support = await getApplicationSupportDirectory();
    return p.join(support.path, 'webview_profile');
  }

  static Future<void> clearProfileData() async {
    await closeAll();
    try {
      final dir = Directory(await userDataDir());
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('AppDesktopBrowser.clearProfileData: $e');
    }
    // Linux WebKitGTK profile (cookies.sqlite + cache) lives outside the
    // Windows-oriented userDataFolder path.
    if (Platform.isLinux) {
      try {
        final home = Platform.environment['HOME'] ?? '';
        if (home.isNotEmpty) {
          for (final rel in [
            '.local/share/gizecare/webkit',
            '.cache/gizecare/webkit',
          ]) {
            final d = Directory(p.join(home, rel));
            if (d.existsSync()) {
              await d.delete(recursive: true);
            }
          }
        }
      } catch (e) {
        debugPrint('AppDesktopBrowser.clearLinuxWebkit: $e');
      }
    }
  }

  static Future<bool> _launchExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
