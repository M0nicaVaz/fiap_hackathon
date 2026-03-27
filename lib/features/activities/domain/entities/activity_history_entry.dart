class ActivityHistoryEntry {
  const ActivityHistoryEntry({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.completedAt,
    required this.positiveMessage,
  });

  final String id;
  final String taskId;
  final String taskTitle;
  final DateTime completedAt;
  final String positiveMessage;
}
