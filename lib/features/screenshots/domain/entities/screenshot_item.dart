import 'package:equatable/equatable.dart';

/// A screenshot captured during a time entry.
class ScreenshotItem extends Equatable {
  const ScreenshotItem({
    required this.id,
    required this.timeEntryId,
    required this.filePath,
    required this.takenAt,
  });

  final String id;
  final String timeEntryId;
  final String filePath;
  final DateTime takenAt;

  @override
  List<Object?> get props => [id, timeEntryId, filePath, takenAt];
}
