import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gizecare/app/router/app_routes.dart';

/// Central link router for ጊዜCare.
///
/// - `http` / `https` / `file` / `data` → in-app [/browser] chrome
/// - `tel` / `mailto` / `tg` / OAuth → system handler
/// - [preferExternal] forces the system browser
abstract final class AppLinkOpener {
  /// Opens [url] in the in-app browser when appropriate.
  static Future<bool> open(
    BuildContext context,
    String url, {
    String? title,
    bool preferExternal = false,
  }) async {
    final normalized = _normalize(url);
    if (normalized == null) return false;
    final uri = Uri.tryParse(normalized);
    if (uri == null) return false;

    if (preferExternal || !_isInAppWeb(uri)) {
      return _launchExternal(uri);
    }

    if (!context.mounted) return false;
    await context.push(AppRoutes.browserPath(uri.toString(), title: title));
    return true;
  }

  static Future<bool> openUri(
    BuildContext context,
    Uri uri, {
    String? title,
    bool preferExternal = false,
  }) {
    return open(
      context,
      uri.toString(),
      title: title,
      preferExternal: preferExternal,
    );
  }

  static Future<bool> openExternal(String url) async {
    final normalized = _normalize(url);
    if (normalized == null) return false;
    final uri = Uri.tryParse(normalized);
    if (uri == null) return false;
    return _launchExternal(uri);
  }

  static bool isInAppWebUrl(String url) {
    final normalized = _normalize(url);
    if (normalized == null) return false;
    final uri = Uri.tryParse(normalized);
    return uri != null && _isInAppWeb(uri);
  }

  /// Turns omnibox input into a navigable URL (or search URL).
  static String resolveOmnibox(String raw, {required String searchUrlTemplate}) {
    final value = raw.trim();
    if (value.isEmpty) return searchUrlTemplate.replaceAll('{query}', '');
    if (value.contains('://') ||
        value.startsWith('about:') ||
        value.startsWith('data:') ||
        value.startsWith('file:')) {
      return value;
    }
    final looksLikeHost = !value.contains(' ') &&
        (value.contains('.') || value.toLowerCase().startsWith('localhost'));
    if (looksLikeHost) return 'https://$value';
    return searchUrlTemplate.replaceAll(
      '{query}',
      Uri.encodeQueryComponent(value),
    );
  }

  static bool _isInAppWeb(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    return scheme == 'http' ||
        scheme == 'https' ||
        scheme == 'file' ||
        scheme == 'data' ||
        scheme == 'about';
  }

  static String? _normalize(String raw) {
    var value = raw.trim();
    if (value.isEmpty) return null;
    if (!value.contains('://') &&
        !value.startsWith('data:') &&
        !value.startsWith('file:') &&
        !value.startsWith('about:')) {
      if (value.contains('.') || value.startsWith('localhost')) {
        value = 'https://$value';
      }
    }
    return value;
  }

  static Future<bool> _launchExternal(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }
}
