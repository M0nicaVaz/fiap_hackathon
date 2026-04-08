import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';

List<Task> filterTasksByQuery(List<Task> tasks, String query) {
  if (query.trim().isEmpty) {
    return tasks;
  }
  final normalizedQuery = query.trim().toLowerCase();
  return tasks
      .where((task) => task.title.toLowerCase().contains(normalizedQuery))
      .toList();
}

String formatTaskProgress(Task task) {
  final total = task.steps.length;
  if (total == 0) {
    return 'Sem etapas';
  }
  return 'Etapas: ${task.completedStepsCount}/$total';
}

String formatTaskReminder(DateTime dateTime) {
  final date =
      '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  final time =
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  return '$date · $time';
}

String formatActivityHistoryDateTime(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}
