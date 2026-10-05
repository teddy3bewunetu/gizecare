import 'package:equatable/equatable.dart';

/// A visited page in the in-app browser history.
class BrowserHistoryEntry extends Equatable {
  const BrowserHistoryEntry({
    required this.id,
    required this.title,
    required this.url,
    required this.visitedAt,
    this.visitCount = 1,
  });

  final String id;
  final String title;
  final String url;
  final DateTime visitedAt;
  final int visitCount;

  @override
  List<Object?> get props => [id, title, url, visitedAt, visitCount];
}
