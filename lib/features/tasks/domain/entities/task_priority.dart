/// Card priority for Kanban tasks.
enum TaskPriority {
  none,
  low,
  medium,
  high,
  urgent;

  static TaskPriority fromStorage(String value) {
    return TaskPriority.values.firstWhere(
      (p) => p.name == value,
      orElse: () => TaskPriority.none,
    );
  }

  String get storage => name;

  String get label => switch (this) {
        TaskPriority.none => 'None',
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.urgent => 'Urgent',
      };
}
