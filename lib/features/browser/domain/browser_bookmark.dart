import 'package:equatable/equatable.dart';

/// A saved browser bookmark.
class BrowserBookmark extends Equatable {
  const BrowserBookmark({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
    this.faviconUrl,
    this.sortOrder = 0,
  });

  final String id;
  final String title;
  final String url;
  final String? faviconUrl;
  final int sortOrder;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, url, faviconUrl, sortOrder, createdAt];
}

/// Supported omnibox search engines.
enum BrowserSearchEngine {
  google,
  duckDuckGo,
  bing;

  String get label => switch (this) {
        BrowserSearchEngine.google => 'Google',
        BrowserSearchEngine.duckDuckGo => 'DuckDuckGo',
        BrowserSearchEngine.bing => 'Bing',
      };

  /// Template with `{query}` placeholder.
  String get searchUrlTemplate => switch (this) {
        BrowserSearchEngine.google =>
          'https://www.google.com/search?q={query}',
        BrowserSearchEngine.duckDuckGo =>
          'https://duckduckgo.com/?q={query}',
        BrowserSearchEngine.bing =>
          'https://www.bing.com/search?q={query}',
      };

  String get homeUrl => switch (this) {
        BrowserSearchEngine.google => 'https://www.google.com/',
        BrowserSearchEngine.duckDuckGo => 'https://duckduckgo.com/',
        BrowserSearchEngine.bing => 'https://www.bing.com/',
      };

  static BrowserSearchEngine fromStorage(String? raw) {
    return BrowserSearchEngine.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => BrowserSearchEngine.google,
    );
  }
}
