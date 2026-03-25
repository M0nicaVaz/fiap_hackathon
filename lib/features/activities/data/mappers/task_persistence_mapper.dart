import '../../domain/entities/activity_history_entry.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/entities/task_step.dart';

abstract final class TaskPersistenceMapper {
  TaskPersistenceMapper._();

  static Map<String, dynamic> taskToMap(Task t) {
    return {
      'id': t.id,
      'title': t.title,
      'description': t.description,
      'steps': t.steps.map(stepToMap).toList(),
      'status': t.status.index,
      'category': t.category.index,
      'reminderAt': t.reminderAt?.toIso8601String(),
      'createdAt': t.createdAt.toIso8601String(),
      'updatedAt': t.updatedAt.toIso8601String(),
    };
  }

  static Map<String, dynamic> stepToMap(TaskStep s) {
    return {
      'id': s.id,
      'label': s.label,
      'order': s.order,
      'completed': s.completed,
    };
  }

  static Task taskFromMap(Map<String, dynamic> m) {
    final catIndex = (m['category'] as int?) ?? 0;
    final category = TaskCategory
        .values[catIndex.clamp(0, TaskCategory.values.length - 1)];
    return Task(
      id: m['id'] as String,
      title: m['title'] as String,
      description: m['description'] as String?,
      steps: (m['steps'] as List<dynamic>)
          .map((e) => stepFromMap(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order)),
      status: TaskStatus
          .values[(m['status'] as int).clamp(0, TaskStatus.values.length - 1)],
      category: category,
      reminderAt: m['reminderAt'] != null
          ? DateTime.tryParse(m['reminderAt'] as String)
          : null,
      createdAt: DateTime.parse(m['createdAt'] as String),
      updatedAt: DateTime.parse(m['updatedAt'] as String),
    );
  }

  static TaskStep stepFromMap(Map<String, dynamic> m) {
    return TaskStep(
      id: m['id'] as String,
      label: m['label'] as String,
      order: m['order'] as int,
      completed: m['completed'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> historyEntryToMap(ActivityHistoryEntry e) {
    return {
      'id': e.id,
      'taskId': e.taskId,
      'taskTitle': e.taskTitle,
      'completedAt': e.completedAt.toIso8601String(),
      'positiveMessage': e.positiveMessage,
    };
  }

  static ActivityHistoryEntry historyEntryFromMap(Map<String, dynamic> m) {
    return ActivityHistoryEntry(
      id: m['id'] as String,
      taskId: m['taskId'] as String,
      taskTitle: m['taskTitle'] as String,
      completedAt: DateTime.parse(m['completedAt'] as String),
      positiveMessage: m['positiveMessage'] as String,
    );
  }
}
