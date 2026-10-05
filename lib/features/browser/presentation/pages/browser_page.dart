import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'package:gizecare/core/browser/app_desktop_browser.dart';
import 'package:gizecare/core/browser/app_link_opener.dart';
import 'package:gizecare/core/browser/browser_injected_scripts.dart';
import 'package:gizecare/core/platform/app_platform.dart';
import 'package:gizecare/core/theme/app_colors.dart';
import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/browser/domain/browser_bookmark.dart';
import 'package:gizecare/features/browser/presentation/providers/browser_providers.dart';
import 'package:gizecare/features/browser/presentation/widgets/browser_history_sheet.dart';
import 'package:gizecare/features/browser/presentation/widgets/browser_settings_sheet.dart';
import 'package:gizecare/features/browser/presentation/widgets/youtube_watch_pane.dart';

/// In-app browser chrome for all platforms (tabs + inspect).
///
/// Desktop (Linux/Windows): Flutter toolbar/tabs + companion WebKit window per
/// tab docked under the content placeholder. Mobile/macOS: embedded webviews.
class BrowserPage extends ConsumerStatefulWidget {
  const BrowserPage({
    required this.initialUrl,
    this.title,
    this.sessionKey,
    super.key,
  });

  final String initialUrl;
  final String? title;

  /// Stable desktop WebKit session id. When set, switching Apps reuses the
  /// same warm window (cookies / history) instead of creating a new one.
  final String? sessionKey;

  @override
  ConsumerState<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserTab {
  _BrowserTab({
    required this.id,
    required this.url,
    required this.title,
  });

  final String id;
  String url;
  String title;
  bool canBack = false;
  bool canForward = false;
  bool loading = true;
  double progress = 0.0;
  WebViewController? mobileController;
}

class _BrowserPageState extends ConsumerState<BrowserPage>
    with WidgetsBindingObserver, WindowListener {
  static const _uuid = Uuid();

  final _urlController = TextEditingController();
  final _urlFocus = FocusNode();
  final _contentKey = GlobalKey();
  final _tabs = <_BrowserTab>[];

  var _activeIndex = 0;
  var _webviewReady = false;
  var _secure = false;
  var _browserFullscreen = false;
  var _routeVisible = true;
  String? _error;
  String? _inAppMediaUrl;
  late final String _sessionKey;

  bool get _useDesktopEngine => AppDesktopBrowser.isAvailable;

  _BrowserTab? get _active =>
      _tabs.isEmpty ? null : _tabs[_activeIndex.clamp(0, _tabs.length - 1)];

  @override
  void initState() {
    super.initState();
    final start = widget.initialUrl.trim().isEmpty ||
            widget.initialUrl == 'about:blank'
        ? ''
        : widget.initialUrl.trim();
    _sessionKey = widget.sessionKey?.trim().isNotEmpty == true
        ? widget.sessionKey!.trim()
        : (start.isEmpty
            ? AppDesktopBrowser.newTabId()
            : AppDesktopBrowser.sessionKeyForUrl(start));
    // Paint the address bar immediately — don't wait for async WebKit boot
    // (avoids briefly showing the previous app's URL).
    if (start.isNotEmpty) {
      _urlController.text = start;
      _secure = start.toLowerCase().startsWith('https://');
    }
    WidgetsBinding.instance.addObserver(this);
    if (_useDesktopEngine) {
      windowManager.addListener(this);
      _bindEngineCallbacks();
    }
    unawaited(_boot());
  }

  void _bindEngineCallbacks() {
    AppDesktopBrowser.onUrlChanged = _onEngineUrl;
    AppDesktopBrowser.onHistoryChanged = _onEngineHistory;
    AppDesktopBrowser.onNavigating = _onEngineNavigating;
    AppDesktopBrowser.onInAppMedia = _onInAppMedia;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_useDesktopEngine) return;
    final visible = ModalRoute.of(context)?.isCurrent ?? true;
    // Root-navigator dialogs make this route non-current; that is not a real
    // leave of Browser — and hideFeature would clear _activeTabId mid-edit.
    if (AppDesktopBrowser.overlayLocked) return;
    if (visible == _routeVisible) return;
    _routeVisible = visible;
    if (visible) {
      _bindEngineCallbacks();
      unawaited(_resumeSession());
    } else {
      _persistFeatureTabs();
      unawaited(AppDesktopBrowser.hideFeature(_sessionKey));
    }
  }

  void _persistFeatureTabs() {
    if (!_useDesktopEngine || _tabs.isEmpty) return;
    AppDesktopBrowser.saveFeatureTabStrip(
      _sessionKey,
      [
        for (final t in _tabs)
          DesktopBrowserTabSnapshot(id: t.id, url: t.url, title: t.title),
      ],
      activeTabId: _active?.id ?? _sessionKey,
    );
  }

  Future<void> _resumeSession() async {
    final active = _active;
    final tabId = active?.id ??
        AppDesktopBrowser.featureActiveTabId(_sessionKey) ??
        _sessionKey;
    final known = AppDesktopBrowser.urlForSession(tabId) ??
        active?.url ??
        AppDesktopBrowser.urlForSession(_sessionKey);
    if (known != null && known.isNotEmpty && mounted && active != null) {
      setState(() {
        active.url = known;
        if (active.title.isEmpty) {
          active.title = widget.title?.trim().isNotEmpty == true
              ? widget.title!.trim()
              : _hostLabel(known);
        }
        _syncChromeFromTab(active);
      });
    }
    await AppDesktopBrowser.openSession(
      tabId,
      known ?? widget.initialUrl,
    );
    if (!mounted) return;
    _scheduleDock();
  }

  Future<void> _boot() async {
    var start = widget.initialUrl.trim().isEmpty ||
            widget.initialUrl == 'about:blank'
        ? 'https://www.google.com/'
        : widget.initialUrl;
    final blank = widget.initialUrl.trim().isEmpty ||
        widget.initialUrl == 'about:blank';
    if (blank) {
      try {
        final engine = await ref.read(browserSearchEngineProvider.future);
        start = engine.homeUrl;
      } catch (_) {}
    }
    if (!mounted) return;
    final title = widget.title?.trim().isNotEmpty == true
        ? widget.title!.trim()
        : _hostLabel(start);

    // Restore previously opened tabs for this feature when available.
    final saved = _useDesktopEngine
        ? AppDesktopBrowser.featureTabStrip(_sessionKey)
        : null;
    if (saved != null && saved.isNotEmpty) {
      await _bootRestoredTabs(saved, fallbackUrl: start, fallbackTitle: title);
      return;
    }

    // Resume warm session when possible (do not force-reload app home).
    final warmUrl = AppDesktopBrowser.urlForSession(_sessionKey);
    final resume = warmUrl != null && warmUrl.isNotEmpty;
    final openUrl = resume ? warmUrl : start;

    final tab = _BrowserTab(
      id: _sessionKey,
      url: openUrl,
      title: title,
    );
    setState(() {
      _tabs
        ..clear()
        ..add(tab);
      _activeIndex = 0;
      _syncChromeFromTab(tab);
      _error = null;
      _loadingFor(tab, !resume);
    });
    _persistFeatureTabs();

    if (_useDesktopEngine) {
      final ok = await AppDesktopBrowser.openSession(
        _sessionKey,
        openUrl,
        forceNavigate: !resume,
      );
      if (!mounted) return;
      if (!ok) {
        setState(() {
          _error = 'Could not start the in-app browser engine.';
          _webviewReady = false;
        });
        return;
      }
      setState(() => _webviewReady = true);
      _scheduleDock();
    } else {
      await _initMobileWebView(tab, openUrl);
      if (!mounted) return;
      setState(() => _webviewReady = true);
    }
  }

  Future<void> _bootRestoredTabs(
    List<DesktopBrowserTabSnapshot> saved, {
    required String fallbackUrl,
    required String fallbackTitle,
  }) async {
    final restored = <_BrowserTab>[
      for (final s in saved)
        _BrowserTab(
          id: s.id,
          url: AppDesktopBrowser.urlForSession(s.id) ??
              (s.url.trim().isEmpty ? fallbackUrl : s.url),
          title: s.title.trim().isEmpty
              ? (s.id == _sessionKey ? fallbackTitle : _hostLabel(s.url))
              : s.title,
        ),
    ];
    final savedActiveId = AppDesktopBrowser.featureActiveTabId(_sessionKey);
    var activeIndex = 0;
    if (savedActiveId != null) {
      final i = restored.indexWhere((t) => t.id == savedActiveId);
      if (i >= 0) activeIndex = i;
    }

    setState(() {
      _tabs
        ..clear()
        ..addAll(restored);
      _activeIndex = activeIndex;
      _syncChromeFromTab(_tabs[activeIndex]);
      _error = null;
      for (final t in _tabs) {
        _loadingFor(t, false);
      }
    });
    _persistFeatureTabs();

    // Activate the previously selected tab first, then warm the others hidden.
    final active = _tabs[activeIndex];
    final ok = await AppDesktopBrowser.openSession(
      active.id,
      active.url,
      forceNavigate: false,
    );
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _error = 'Could not start the in-app browser engine.';
        _webviewReady = false;
      });
      return;
    }

    for (final tab in _tabs) {
      if (tab.id == active.id) continue;
      await AppDesktopBrowser.openSession(
        tab.id,
        tab.url,
        forceNavigate: false,
        activate: false,
      );
      if (!mounted) return;
    }
    await AppDesktopBrowser.activateTab(active.id);
    if (!mounted) return;
    setState(() => _webviewReady = true);
    _scheduleDock();
  }

  Future<void> _openTab({
    required String url,
    String? title,
    bool activate = true,
  }) async {
    final tab = _BrowserTab(
      id: _useDesktopEngine ? AppDesktopBrowser.newTabId() : _uuid.v4(),
      url: url,
      title: title?.trim().isNotEmpty == true ? title!.trim() : _hostLabel(url),
    );
    setState(() {
      _tabs.add(tab);
      if (activate) {
        _activeIndex = _tabs.length - 1;
        _syncChromeFromTab(tab);
      }
      _error = null;
      _loadingFor(tab, true);
    });
    _persistFeatureTabs();

    if (_useDesktopEngine) {
      final ok = await AppDesktopBrowser.openTab(tab.id, url, activate: activate);
      if (!mounted) return;
      if (!ok) {
        setState(() {
          _error = 'Could not start the in-app browser engine.';
          _webviewReady = false;
        });
        return;
      }
      setState(() => _webviewReady = true);
      _scheduleDock();
    } else {
      await _initMobileWebView(tab, url);
      if (!mounted) return;
      setState(() => _webviewReady = true);
    }
  }

  void _loadingFor(_BrowserTab tab, bool loading) {
    tab.loading = loading;
    if (loading) tab.progress = 0.15;
  }

  void _syncChromeFromTab(_BrowserTab tab) {
    _secure = tab.url.toLowerCase().startsWith('https://');
    if (!_urlFocus.hasFocus) {
      _urlController.text = tab.url;
      _urlController.selection =
          TextSelection.collapsed(offset: tab.url.length);
    }
  }

  Future<void> _switchTab(int index) async {
    if (index < 0 || index >= _tabs.length || index == _activeIndex) return;
    setState(() {
      _activeIndex = index;
      _syncChromeFromTab(_tabs[index]);
    });
    _persistFeatureTabs();
    if (_useDesktopEngine) {
      await AppDesktopBrowser.activateTab(_tabs[index].id);
      _scheduleDock();
    }
  }

  Future<void> _closeTabAt(int index) async {
    if (index < 0 || index >= _tabs.length) return;
    final tab = _tabs[index];
    if (_tabs.length == 1) {
      // Closing the last tab leaves the browser route.
      if (_useDesktopEngine) {
        await AppDesktopBrowser.closeTab(tab.id);
        AppDesktopBrowser.clearFeatureTabStrip(_sessionKey);
      }
      _closeBrowser();
      return;
    }
    if (_useDesktopEngine) {
      await AppDesktopBrowser.closeTab(tab.id);
    }
    tab.mobileController = null;
    setState(() {
      _tabs.removeAt(index);
      if (_activeIndex >= _tabs.length) {
        _activeIndex = _tabs.length - 1;
      } else if (index < _activeIndex) {
        _activeIndex -= 1;
      }
      _syncChromeFromTab(_tabs[_activeIndex]);
    });
    _persistFeatureTabs();
    if (_useDesktopEngine) {
      await AppDesktopBrowser.activateTab(_tabs[_activeIndex].id);
      WidgetsBinding.instance.addPostFrameCallback((_) => _dockDesktop());
    }
  }

  Future<void> _newTab() async {
    var home = 'https://www.google.com/';
    try {
      final engine = await ref.read(browserSearchEngineProvider.future);
      home = engine.homeUrl;
    } catch (_) {}
    if (!mounted) return;
    await _openTab(url: home, activate: true);
  }

  void _onEngineUrl(String tabId, String url) {
    if (!mounted) return;
    if (url == 'about:blank' || url.trim().isEmpty) return;
    if (_isTransientGoogleChromeUrl(url)) return;
    if (YoutubeWatchPane.isWatchUrl(url)) {
      _onInAppMedia(tabId, url);
      return;
    }
    final i = _tabs.indexWhere((t) => t.id == tabId);
    if (i < 0) return;
    setState(() {
      final tab = _tabs[i];
      tab.url = url;
      tab.loading = false;
      tab.progress = 1;
      final host = _hostLabel(url);
      if (tab.title.isEmpty ||
          tab.title == _hostLabel(widget.initialUrl) ||
          tab.title == _hostLabel(tab.url) ||
          tab.title == host) {
        tab.title = host;
      }
      if (i == _activeIndex) _syncChromeFromTab(tab);
    });
    _persistFeatureTabs();
    unawaited(
      ref.read(browserHistoryRepositoryProvider).recordVisit(
            url: url,
            title: _tabs[i].title,
          ),
    );
  }

  void _onInAppMedia(String tabId, String url) {
    if (!mounted) return;
    if (!YoutubeWatchPane.isWatchUrl(url)) return;
    _dockRetryTimer?.cancel();
    _lastDockOffset = null;
    _lastDockSize = null;
    setState(() => _inAppMediaUrl = url);
    unawaited(AppDesktopBrowser.hide());
  }

  Future<void> _closeInAppMedia() async {
    if (!mounted) return;
    setState(() => _inAppMediaUrl = null);
    if (_useDesktopEngine) {
      await AppDesktopBrowser.show();
      _scheduleDock();
    }
  }

  void _onEngineHistory(
    String tabId, {
    required bool canGoBack,
    required bool canGoForward,
  }) {
    if (!mounted) return;
    final i = _tabs.indexWhere((t) => t.id == tabId);
    if (i < 0) return;
    setState(() {
      _tabs[i].canBack = canGoBack;
      _tabs[i].canForward = canGoForward;
    });
  }

  void _onEngineNavigating(String tabId, bool navigating) {
    if (!mounted) return;
    final i = _tabs.indexWhere((t) => t.id == tabId);
    if (i < 0) return;
    setState(() {
      _loadingFor(_tabs[i], navigating);
    });
  }

  Offset? _lastDockOffset;
  Size? _lastDockSize;
  Timer? _dockRetryTimer;

  void _dockDesktop({bool force = false}) {
    if (!_useDesktopEngine || !mounted) return;
    // In-app YouTube player owns the content pane — keep the companion
    // WebKit window hidden so it cannot cover Flutter media_kit.
    if (_inAppMediaUrl != null || AppDesktopBrowser.overlayLocked) return;
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;
    if (!force &&
        _lastDockOffset == offset &&
        _lastDockSize == size) {
      return;
    }
    _lastDockOffset = offset;
    _lastDockSize = size;
    unawaited(AppDesktopBrowser.dockTo(offset, size));
  }

  /// Maximize/restore/fullscreen settle over several frames — re-dock repeatedly.
  void _scheduleDock({bool force = true}) {
    if (!_useDesktopEngine || !mounted) return;
    if (_inAppMediaUrl != null || AppDesktopBrowser.overlayLocked) return;
    if (force) {
      _lastDockOffset = null;
      _lastDockSize = null;
    }
    void dockSoon() {
      if (!mounted) return;
      if (_inAppMediaUrl != null || AppDesktopBrowser.overlayLocked) return;
      if (force) {
        _lastDockOffset = null;
        _lastDockSize = null;
      }
      _dockDesktop(force: force);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dockSoon();
      WidgetsBinding.instance.addPostFrameCallback((_) => dockSoon());
    });
    _dockRetryTimer?.cancel();
    _dockRetryTimer = Timer(const Duration(milliseconds: 80), () {
      dockSoon();
      _dockRetryTimer = Timer(const Duration(milliseconds: 140), dockSoon);
    });
  }

  @override
  void onWindowMove() => _dockDesktop();

  @override
  void onWindowMoved() => _dockDesktop();

  @override
  void onWindowResize() => _scheduleDock();

  @override
  void onWindowResized() => _scheduleDock();

  @override
  void onWindowMaximize() => _scheduleDock();

  @override
  void onWindowUnmaximize() => _scheduleDock();

  @override
  void onWindowRestore() {
    if (_inAppMediaUrl != null || AppDesktopBrowser.overlayLocked) return;
    unawaited(AppDesktopBrowser.show());
    _scheduleDock();
  }

  @override
  void onWindowMinimize() {
    unawaited(AppDesktopBrowser.hide());
  }

  @override
  void reassemble() {
    super.reassemble();
    // After hot reload the bootstrap hides orphan windows — re-dock if we
    // still own a live browser session.
    if (_useDesktopEngine &&
        _routeVisible &&
        _webviewReady &&
        _inAppMediaUrl == null &&
        !AppDesktopBrowser.overlayLocked) {
      unawaited(AppDesktopBrowser.show());
      _scheduleDock();
    }
  }

  @override
  void onWindowEnterFullScreen() {
    if (!_browserFullscreen) {
      setState(() => _browserFullscreen = true);
      ref.read(browserFullscreenProvider.notifier).state = true;
    }
    _scheduleDock();
  }

  @override
  void onWindowLeaveFullScreen() {
    if (_browserFullscreen) {
      setState(() => _browserFullscreen = false);
      ref.read(browserFullscreenProvider.notifier).state = false;
    }
    _scheduleDock();
  }

  Future<void> _initMobileWebView(_BrowserTab tab, String startUrl) async {
    try {
      final controller = WebViewController();
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (!mounted) return;
            setState(() {
              tab.progress = p / 100.0;
              tab.loading = p < 100;
            });
          },
          onPageStarted: (url) {
            if (!mounted) return;
            setState(() {
              tab.loading = true;
              _error = null;
              tab.url = url;
              if (identical(_active, tab)) _syncChromeFromTab(tab);
            });
          },
          onPageFinished: (url) async {
            if (!mounted) return;
            try {
              await controller.runJavaScript(
                BrowserInjectedScripts.ctrlEnterNewline,
              );
            } catch (_) {}
            tab.url = url;
            final back = await controller.canGoBack();
            final forward = await controller.canGoForward();
            final title = await controller.getTitle();
            setState(() {
              tab.loading = false;
              tab.progress = 1;
              tab.canBack = back;
              tab.canForward = forward;
              if (title != null && title.trim().isNotEmpty) {
                tab.title = title.trim();
              } else {
                tab.title = _hostLabel(url);
              }
              if (identical(_active, tab)) _syncChromeFromTab(tab);
            });
            unawaited(
              ref.read(browserHistoryRepositoryProvider).recordVisit(
                    url: url,
                    title: tab.title,
                  ),
            );
          },
          onUrlChange: (change) {
            final url = change.url;
            if (url == null || !mounted) return;
            setState(() {
              tab.url = url;
              if (identical(_active, tab)) _syncChromeFromTab(tab);
            });
          },
          onWebResourceError: (error) {
            if (!mounted) return;
            setState(() {
              tab.loading = false;
              if (identical(_active, tab)) _error = error.description;
            });
          },
          onNavigationRequest: (request) {
            if (AppLinkOpener.isInAppWebUrl(request.url)) {
              return NavigationDecision.navigate;
            }
            unawaited(AppLinkOpener.openExternal(request.url));
            return NavigationDecision.prevent;
          },
        ),
      );
      await controller.loadRequest(Uri.parse(startUrl));
      if (!mounted) return;
      setState(() => tab.mobileController = controller);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        tab.loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _goBack() async {
    final tab = _active;
    if (tab == null) return;
    if (_useDesktopEngine) {
      await AppDesktopBrowser.goBack();
    } else if (tab.mobileController != null &&
        await tab.mobileController!.canGoBack()) {
      await tab.mobileController!.goBack();
    }
  }

  Future<void> _goForward() async {
    final tab = _active;
    if (tab == null) return;
    if (_useDesktopEngine) {
      await AppDesktopBrowser.goForward();
    } else if (tab.mobileController != null &&
        await tab.mobileController!.canGoForward()) {
      await tab.mobileController!.goForward();
    }
  }

  Future<void> _reloadOrStop() async {
    final tab = _active;
    if (tab == null) return;
    if (tab.loading) {
      if (_useDesktopEngine) {
        await AppDesktopBrowser.stop();
      }
      setState(() => tab.loading = false);
      return;
    }
    setState(() {
      _loadingFor(tab, true);
      _error = null;
    });
    if (_useDesktopEngine) {
      await AppDesktopBrowser.reload();
    } else {
      await tab.mobileController?.reload();
    }
  }

  Future<void> _submitOmnibox(String raw) async {
    final tab = _active;
    if (tab == null) return;
    final engine = ref.read(browserSearchEngineProvider).valueOrNull ??
        BrowserSearchEngine.google;
    final url = AppLinkOpener.resolveOmnibox(
      raw,
      searchUrlTemplate: engine.searchUrlTemplate,
    );
    setState(() {
      _loadingFor(tab, true);
      _error = null;
      tab.url = url;
      tab.title = _hostLabel(url);
      _syncChromeFromTab(tab);
    });
    _urlFocus.unfocus();
    if (_useDesktopEngine) {
      await AppDesktopBrowser.navigate(url);
      WidgetsBinding.instance.addPostFrameCallback((_) => _dockDesktop());
    } else {
      await tab.mobileController?.loadRequest(Uri.parse(url));
    }
  }

  Future<void> _toggleBookmark() async {
    final tab = _active;
    if (tab == null) return;
    final pageUrl = _canonicalPageUrl(tab.url, fallbackTitle: tab.title);
    if (pageUrl == null) {
      AppSnackBar.show(context, 'Cannot bookmark this page');
      return;
    }
    final repo = ref.read(browserBookmarkRepositoryProvider);
    final bookmarks = ref.read(browserBookmarksProvider).valueOrNull ?? [];
    BrowserBookmark? found;
    for (final b in bookmarks) {
      final canon = _canonicalPageUrl(b.url, fallbackTitle: b.title) ?? b.url;
      if (canon == pageUrl || b.url == tab.url) {
        found = b;
        break;
      }
    }
    if (found != null) {
      await repo.remove(found.id);
      if (mounted) AppSnackBar.show(context, 'Bookmark removed');
    } else {
      final title = tab.title.trim().isEmpty ? _hostLabel(pageUrl) : tab.title;
      await repo.add(
        title: title,
        url: pageUrl,
        faviconUrl: _BookmarkFavicon.urlFor(pageUrl),
      );
      if (mounted) AppSnackBar.show(context, 'Bookmark saved');
    }
  }

  Future<void> _removeBookmark(BrowserBookmark bookmark) async {
    await ref.read(browserBookmarkRepositoryProvider).remove(bookmark.id);
    if (mounted) AppSnackBar.show(context, 'Bookmark removed');
  }

  Future<void> _openBookmark(BrowserBookmark bookmark) async {
    // Leave YouTube / in-app media overlay so the desktop WebKit surface can
    // show the bookmarked page.
    if (_inAppMediaUrl != null) {
      setState(() => _inAppMediaUrl = null);
      if (_useDesktopEngine) {
        await AppDesktopBrowser.show();
      }
    }

    final engine = ref.read(browserSearchEngineProvider).valueOrNull ??
        BrowserSearchEngine.google;
    final resolved = AppLinkOpener.resolveOmnibox(
      bookmark.url.trim().isEmpty ? bookmark.title : bookmark.url,
      searchUrlTemplate: engine.searchUrlTemplate,
    );
    final target = _canonicalPageUrl(
          resolved,
          fallbackTitle: bookmark.title,
        ) ??
        resolved;
    final title = bookmark.title.trim().isNotEmpty
        ? bookmark.title.trim()
        : _hostLabel(target);

    // Repair bad / widget URLs stored from earlier sessions.
    if (target != bookmark.url) {
      unawaited(
        ref.read(browserBookmarkRepositoryProvider).update(
              id: bookmark.id,
              title: title,
              url: target,
              faviconUrl: _BookmarkFavicon.urlFor(target),
            ),
      );
    }

    // Always open bookmarks in a new tab so the current page is preserved.
    await _openTab(url: target, title: title, activate: true);
    if (!mounted) return;
    final tab = _active;
    if (tab != null) {
      setState(() {
        tab.url = target;
        tab.title = title;
        _syncChromeFromTab(tab);
      });
    }
  }

  Future<void> _showBookmarksMenu(BuildContext buttonContext) async {
    final bookmarks = ref.read(browserBookmarksProvider).valueOrNull ?? [];
    final box = buttonContext.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(Offset.zero, ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    // Menu paints in Flutter; companion WebKit would cover it. Keep a lock
    // through edit so lifecycle `resumed` cannot re-show the page.
    if (_useDesktopEngine) {
      await AppDesktopBrowser.beginOverlay();
    }
    if (!mounted || !buttonContext.mounted) {
      if (_useDesktopEngine) {
        await AppDesktopBrowser.endOverlay(restore: mounted && _routeVisible);
      }
      return;
    }
    _BookmarkMenuChoice? choice;
    try {
      choice = await showMenu<_BookmarkMenuChoice>(
        context: buttonContext,
        position: position,
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 360),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        items: [
          if (bookmarks.isEmpty)
            const PopupMenuItem<_BookmarkMenuChoice>(
              enabled: false,
              child: Text('No bookmarks yet'),
            )
          else
            for (final b in bookmarks)
              PopupMenuItem<_BookmarkMenuChoice>(
                value: _BookmarkMenuChoice.open(b),
                child: Builder(
                  builder: (menuContext) {
                    final muted =
                        Theme.of(menuContext).colorScheme.onSurfaceVariant;
                    return Row(
                      children: [
                        _BookmarkFavicon(
                          pageUrl: b.url,
                          faviconUrl: b.faviconUrl,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            b.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Edit',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          onPressed: () => Navigator.pop(
                            menuContext,
                            _BookmarkMenuChoice.edit(b),
                          ),
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: muted,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          onPressed: () => Navigator.pop(
                            menuContext,
                            _BookmarkMenuChoice.remove(b),
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: muted,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
        ],
      );
    } finally {
      // Keep the lock if we are about to open the edit dialog; otherwise
      // restore the page under the menu.
      final keepLocked = _useDesktopEngine &&
          choice != null &&
          choice.kind == _BookmarkMenuKind.edit;
      if (_useDesktopEngine && !keepLocked) {
        await AppDesktopBrowser.endOverlay(
          restore: mounted && _routeVisible && _inAppMediaUrl == null,
        );
        if (mounted && _routeVisible && _inAppMediaUrl == null) {
          _scheduleDock();
        }
      }
    }

    if (!mounted || choice == null) return;
    switch (choice.kind) {
      case _BookmarkMenuKind.open:
        await _openBookmark(choice.bookmark);
      case _BookmarkMenuKind.edit:
        await _editBookmark(choice.bookmark, overlayAlreadyHeld: true);
      case _BookmarkMenuKind.remove:
        await _removeBookmark(choice.bookmark);
    }
  }

  Future<void> _editBookmark(
    BrowserBookmark bookmark, {
    bool overlayAlreadyHeld = false,
  }) async {
    final initialUrl = _canonicalPageUrl(
          bookmark.url,
          fallbackTitle: bookmark.title,
        ) ??
        bookmark.url;

    // Companion WebKit sits above Flutter. hide() alone is not enough:
    // AppLifecycleState.resumed / activateTab re-show the surface immediately.
    if (_useDesktopEngine && !overlayAlreadyHeld) {
      await AppDesktopBrowser.beginOverlay();
    }
    _EditedBookmark? result;
    try {
      if (!mounted) return;
      // Let GTK finish gtk_widget_hide before the dialog paints.
      await Future<void>.delayed(const Duration(milliseconds: 32));
      if (!mounted) return;
      result = await showDialog<_EditedBookmark>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        builder: (context) => _EditBookmarkDialog(
          initialTitle: bookmark.title,
          initialUrl: initialUrl,
        ),
      );
    } finally {
      if (_useDesktopEngine) {
        await AppDesktopBrowser.endOverlay(
          restore: mounted && _routeVisible && _inAppMediaUrl == null,
        );
        if (mounted && _routeVisible && _inAppMediaUrl == null) {
          _scheduleDock();
        }
      }
    }
    if (result == null || !mounted) return;

    final engine = ref.read(browserSearchEngineProvider).valueOrNull ??
        BrowserSearchEngine.google;
    final normalized = AppLinkOpener.resolveOmnibox(
      result.url,
      searchUrlTemplate: engine.searchUrlTemplate,
    );
    final pageUrl =
        _canonicalPageUrl(normalized, fallbackTitle: result.title) ??
            normalized;
    if (pageUrl.trim().isEmpty) {
      AppSnackBar.show(context, 'Enter a valid URL');
      return;
    }

    final update = await ref.read(browserBookmarkRepositoryProvider).update(
          id: bookmark.id,
          title:
              result.title.trim().isEmpty ? _hostLabel(pageUrl) : result.title.trim(),
          url: pageUrl,
          faviconUrl: _BookmarkFavicon.urlFor(pageUrl),
        );
    if (!mounted) return;
    update.when(
      onSuccess: (_) => AppSnackBar.show(context, 'Bookmark updated'),
      onFailure: (f) => AppSnackBar.show(context, f.message),
    );
  }

  Future<void> _openExternal() async {
    final tab = _active;
    if (tab == null) return;
    final uri = Uri.tryParse(tab.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copyUrl() async {
    final tab = _active;
    if (tab == null) return;
    await Clipboard.setData(ClipboardData(text: tab.url));
    if (!mounted) return;
    AppSnackBar.show(context, 'Link copied');
  }

  Future<void> _inspect() async {
    if (!_useDesktopEngine) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        'Inspect is available on Linux/Windows desktop',
      );
      return;
    }
    await AppDesktopBrowser.openDevTools();
  }

  Future<void> _toggleFullscreen({bool? enabled}) async {
    final next = enabled ?? !_browserFullscreen;
    setState(() => _browserFullscreen = next);
    ref.read(browserFullscreenProvider.notifier).state = next;
    _lastDockOffset = null;

    if (_useDesktopEngine || AppPlatform.isDesktop) {
      try {
        await windowManager.setFullScreen(next);
      } catch (e) {
        debugPrint('Browser fullscreen: $e');
      }
    } else {
      if (next) {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }

    if (!mounted) return;
    _scheduleDock();
  }

  void _closeBrowser() {
    unawaited(_exitFullscreenIfNeeded());
    unawaited(AppDesktopBrowser.hide());
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  Future<void> _exitFullscreenIfNeeded() async {
    if (!_browserFullscreen) return;
    ref.read(browserFullscreenProvider.notifier).state = false;
    _browserFullscreen = false;
    try {
      if (await windowManager.isFullScreen()) {
        await windowManager.setFullScreen(false);
      }
    } catch (_) {}
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Do NOT hide the companion WebKit window on inactive/paused.
    // Clicking page content focuses WebKit and blurs Flutter — treating that
    // as background hides the page and steals the text cursor (blink loop).
    if (!_useDesktopEngine) return;
    if (state == AppLifecycleState.resumed) {
      if (_inAppMediaUrl != null || AppDesktopBrowser.overlayLocked) return;
      unawaited(AppDesktopBrowser.show());
      _scheduleDock();
    }
  }

  @override
  void dispose() {
    _dockRetryTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    if (_useDesktopEngine) {
      windowManager.removeListener(this);
      _persistFeatureTabs();
      unawaited(AppDesktopBrowser.hideFeature(_sessionKey));
    }
    if (_browserFullscreen) {
      ref.read(browserFullscreenProvider.notifier).state = false;
      unawaited(windowManager.setFullScreen(false));
      unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
    }
    // Only clear engine callbacks if we still own them (another BrowserPage
    // may have already rebound while this one was disposing).
    if (AppDesktopBrowser.onUrlChanged == _onEngineUrl) {
      AppDesktopBrowser.onUrlChanged = null;
      AppDesktopBrowser.onHistoryChanged = null;
      AppDesktopBrowser.onNavigating = null;
      AppDesktopBrowser.onInAppMedia = null;
    }
    _urlController.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  static String _hostLabel(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return 'New Tab';
    if (uri.host.isNotEmpty) return uri.host;
    if (uri.scheme == 'file') return 'Local file';
    return 'New Tab';
  }

  /// Google account / One Tap / app widgets that briefly steal the top frame.
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

  /// Real page URL for bookmarks / navigation — never ogs.google.com widgets.
  static String? _canonicalPageUrl(String url, {String? fallbackTitle}) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;
    if (!_isTransientGoogleChromeUrl(trimmed)) {
      return trimmed;
    }
    final uri = Uri.tryParse(trimmed);
    final origin = uri?.queryParameters['origin']?.trim();
    if (origin != null &&
        origin.isNotEmpty &&
        !_isTransientGoogleChromeUrl(origin)) {
      return origin;
    }
    final title = fallbackTitle?.trim() ?? '';
    if (title.contains('.') &&
        !title.contains(' ') &&
        !title.contains('://')) {
      return 'https://$title';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarks = ref.watch(browserBookmarksProvider).valueOrNull ?? [];
    final tab = _active;
    final currentUrl = tab?.url ?? '';
    final isBookmarked = bookmarks.any((b) => b.url == currentUrl);
    final loading = tab?.loading ?? false;
    final progress = tab?.progress ?? 0.0;
    final canBack = tab?.canBack ?? false;
    final canForward = tab?.canForward ?? false;
    final pageTitle = tab?.title ?? 'Browser';

    // No autofocus Focus — rebuilds were stealing keyboard focus from WebKit
    // page inputs (Google search, etc.). Shortcuts still work when chrome
    // widgets hold focus.
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyT, control: true): () {
          unawaited(_newTab());
        },
        const SingleActivator(LogicalKeyboardKey.keyT, meta: true): () {
          unawaited(_newTab());
        },
        const SingleActivator(LogicalKeyboardKey.keyW, control: true): () {
          unawaited(_closeTabAt(_activeIndex));
        },
        const SingleActivator(LogicalKeyboardKey.keyW, meta: true): () {
          unawaited(_closeTabAt(_activeIndex));
        },
        const SingleActivator(LogicalKeyboardKey.f11): () {
          unawaited(_toggleFullscreen());
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (_browserFullscreen) unawaited(_toggleFullscreen(enabled: false));
        },
        const SingleActivator(LogicalKeyboardKey.f12): () {
          unawaited(_inspect());
        },
        const SingleActivator(
          LogicalKeyboardKey.keyI,
          control: true,
          shift: true,
        ): () {
          unawaited(_inspect());
        },
        const SingleActivator(
          LogicalKeyboardKey.keyI,
          meta: true,
          shift: true,
        ): () {
          unawaited(_inspect());
        },
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        body: Column(
          children: [
            if (_browserFullscreen)
              Material(
                color: isDark ? AppColors.darkSurfaceHigh : Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Exit fullscreen (Esc / F11)',
                          onPressed: () =>
                              unawaited(_toggleFullscreen(enabled: false)),
                          icon: const Icon(Icons.fullscreen_exit_rounded),
                        ),
                        Expanded(
                          child: Text(
                            pageTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        if (loading)
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Material(
              color: isDark ? AppColors.darkSurfaceHigh : Colors.white,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _TabStrip(
                      tabs: _tabs,
                      activeIndex: _activeIndex,
                      isDark: isDark,
                      onSelect: _switchTab,
                      onClose: _closeTabAt,
                      onNewTab: _newTab,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Close browser',
                            onPressed: _closeBrowser,
                            icon: const Icon(Icons.close_rounded),
                          ),
                          IconButton(
                            tooltip: 'Back',
                            onPressed: canBack ? _goBack : null,
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          IconButton(
                            tooltip: 'Forward',
                            onPressed: canForward ? _goForward : null,
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                          IconButton(
                            tooltip: loading ? 'Stop' : 'Reload',
                            onPressed: _webviewReady ? _reloadOrStop : null,
                            icon: Icon(
                              loading
                                  ? Icons.close_rounded
                                  : Icons.refresh_rounded,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _Omnibox(
                              controller: _urlController,
                              focusNode: _urlFocus,
                              secure: _secure,
                              onSubmitted: _submitOmnibox,
                            ),
                          ),
                          IconButton(
                            tooltip: isBookmarked
                                ? 'Remove bookmark'
                                : 'Bookmark this page',
                            onPressed: _webviewReady ? _toggleBookmark : null,
                            icon: Icon(
                              isBookmarked
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: isBookmarked ? AppColors.warning : null,
                            ),
                          ),
                          Builder(
                            builder: (buttonContext) {
                              return IconButton(
                                tooltip: 'Bookmarks',
                                onPressed: () => unawaited(
                                  _showBookmarksMenu(buttonContext),
                                ),
                                icon: Badge(
                                  isLabelVisible: bookmarks.isNotEmpty,
                                  smallSize: 8,
                                  backgroundColor: AppColors.brand,
                                  child: const Icon(Icons.bookmarks_outlined),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            tooltip: 'Fullscreen (F11)',
                            onPressed: () => unawaited(_toggleFullscreen()),
                            icon: const Icon(Icons.fullscreen_rounded),
                          ),
                          PopupMenuButton<_ChromeMenu>(
                            tooltip: 'More',
                            onSelected: (value) async {
                              switch (value) {
                                case _ChromeMenu.newTab:
                                  await _newTab();
                                case _ChromeMenu.history:
                                  await showBrowserHistorySheet(
                                    context,
                                    ref,
                                    onOpenUrl: _submitOmnibox,
                                  );
                                case _ChromeMenu.fullscreen:
                                  await _toggleFullscreen();
                                case _ChromeMenu.inspect:
                                  await _inspect();
                                case _ChromeMenu.copy:
                                  await _copyUrl();
                                case _ChromeMenu.external:
                                  await _openExternal();
                                case _ChromeMenu.settings:
                                  await showBrowserSettingsSheet(context, ref);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: _ChromeMenu.newTab,
                                child: Text('New tab'),
                              ),
                              const PopupMenuItem(
                                value: _ChromeMenu.history,
                                child: Text('History'),
                              ),
                              PopupMenuItem(
                                value: _ChromeMenu.fullscreen,
                                child: Text(
                                  _browserFullscreen
                                      ? 'Exit fullscreen'
                                      : 'Fullscreen',
                                ),
                              ),
                              const PopupMenuItem(
                                value: _ChromeMenu.inspect,
                                child: Text('Inspect'),
                              ),
                              const PopupMenuItem(
                                value: _ChromeMenu.copy,
                                child: Text('Copy link'),
                              ),
                              const PopupMenuItem(
                                value: _ChromeMenu.external,
                                child: Text('Open in system browser'),
                              ),
                              const PopupMenuItem(
                                value: _ChromeMenu.settings,
                                child: Text('Browser settings'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: loading ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: LinearProgressIndicator(
                        value: progress <= 0 || progress >= 1 ? null : progress,
                        minHeight: 2,
                        backgroundColor: Colors.transparent,
                        color: AppColors.brand,
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: isDark
                          ? AppColors.darkOutline
                          : AppColors.lightOutline.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (_) {
                _scheduleDock();
                return false;
              },
                child: SizeChangedLayoutNotifier(
                  child: KeyedSubtree(
                    key: _contentKey,
                    child: _buildContent(scheme, isDark),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme scheme, bool isDark) {
    final mediaUrl = _inAppMediaUrl;
    if (mediaUrl != null) {
      return YoutubeWatchPane(
        url: mediaUrl,
        onClose: () => unawaited(_closeInAppMedia()),
      );
    }

    if (_error != null && !_webviewReady) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: 48, color: AppColors.brand),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openExternal,
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Open externally'),
              ),
            ],
          ),
        ),
      );
    }

    if (_useDesktopEngine) {
      return ColoredBox(
        color: isDark ? Colors.black : const Color(0xFFF5F7FA),
        child: Center(
          child: Text(
            _webviewReady ? 'Loading page…' : 'Starting browser…',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      );
    }

    if (_tabs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return IndexedStack(
      index: _activeIndex,
      children: [
        for (final tab in _tabs)
          if (tab.mobileController == null)
            const Center(child: CircularProgressIndicator())
          else
            ColoredBox(
              color: isDark ? Colors.black : Colors.white,
              child: WebViewWidget(controller: tab.mobileController!),
            ),
      ],
    );
  }
}

enum _ChromeMenu {
  newTab,
  history,
  fullscreen,
  inspect,
  copy,
  external,
  settings,
}

enum _BookmarkMenuKind { open, edit, remove }

class _BookmarkMenuChoice {
  const _BookmarkMenuChoice._(this.kind, this.bookmark);

  const _BookmarkMenuChoice.open(BrowserBookmark bookmark)
      : this._(_BookmarkMenuKind.open, bookmark);

  const _BookmarkMenuChoice.edit(BrowserBookmark bookmark)
      : this._(_BookmarkMenuKind.edit, bookmark);

  const _BookmarkMenuChoice.remove(BrowserBookmark bookmark)
      : this._(_BookmarkMenuKind.remove, bookmark);

  final _BookmarkMenuKind kind;
  final BrowserBookmark bookmark;
}

class _TabStrip extends StatelessWidget {
  const _TabStrip({
    required this.tabs,
    required this.activeIndex,
    required this.isDark,
    required this.onSelect,
    required this.onClose,
    required this.onNewTab,
  });

  final List<_BrowserTab> tabs;
  final int activeIndex;
  final bool isDark;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onClose;
  final VoidCallback onNewTab;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 8, top: 4, bottom: 0),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final selected = index == activeIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Material(
                    color: selected
                        ? (isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurface)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      onTap: () => onSelect(index),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 120,
                          maxWidth: 200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 4),
                          child: Row(
                            children: [
                              if (tab.loading)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                )
                              else
                                _BookmarkFavicon(pageUrl: tab.url),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tab.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Close tab',
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                padding: EdgeInsets.zero,
                                iconSize: 16,
                                onPressed: () => onClose(index),
                                icon: const Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            tooltip: 'New tab (Ctrl+T)',
            onPressed: onNewTab,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _EditedBookmark {
  const _EditedBookmark({required this.title, required this.url});

  final String title;
  final String url;
}

class _EditBookmarkDialog extends StatefulWidget {
  const _EditBookmarkDialog({
    required this.initialTitle,
    required this.initialUrl,
  });

  final String initialTitle;
  final String initialUrl;

  @override
  State<_EditBookmarkDialog> createState() => _EditBookmarkDialogState();
}

class _EditBookmarkDialogState extends State<_EditBookmarkDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _urlCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle);
    _urlCtrl = TextEditingController(text: widget.initialUrl);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(
      context,
      _EditedBookmark(title: _titleCtrl.text, url: _urlCtrl.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit bookmark'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlCtrl,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _BookmarkFavicon extends StatelessWidget {
  const _BookmarkFavicon({
    required this.pageUrl,
    this.faviconUrl,
  });

  final String pageUrl;
  final String? faviconUrl;

  /// Google's favicon service — works for most sites without needing a crawl.
  static String? urlFor(String pageUrl) {
    final uri = Uri.tryParse(pageUrl.trim());
    final host = uri?.host;
    if (host == null || host.isEmpty) return null;
    return 'https://www.google.com/s2/favicons?domain=$host&sz=64';
  }

  @override
  Widget build(BuildContext context) {
    final url = (faviconUrl != null && faviconUrl!.trim().isNotEmpty)
        ? faviconUrl!.trim()
        : urlFor(pageUrl);
    const size = 18.0;
    if (url == null) {
      return Icon(
        Icons.public_rounded,
        size: size,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(
          Icons.public_rounded,
          size: size,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        // Avoid jank when opening the menu with many bookmarks.
        gaplessPlayback: true,
      ),
    );
  }
}

class _Omnibox extends StatelessWidget {
  const _Omnibox({
    required this.controller,
    required this.focusNode,
    required this.secure,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool secure;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.bodyMedium,
        textInputAction: TextInputAction.go,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor:
              isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          prefixIcon: Icon(
            secure ? Icons.lock_rounded : Icons.search_rounded,
            size: 16,
            color: secure ? AppColors.success : AppColors.brand,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 36),
          hintText: 'Search or enter address',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.brand, width: 1.4),
          ),
        ),
      ),
    );
  }
}
