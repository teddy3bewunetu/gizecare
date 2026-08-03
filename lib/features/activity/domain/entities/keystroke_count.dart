import 'package:equatable/equatable.dart';

/// One key’s press count within a time entry.
class KeystrokeCount extends Equatable {
  const KeystrokeCount({
    required this.id,
    required this.timeEntryId,
    required this.keyLabel,
    required this.count,
  });

  final String id;
  final String timeEntryId;
  final String keyLabel;
  final int count;

  @override
  List<Object?> get props => [id, timeEntryId, keyLabel, count];
}
