import '../entities/activity_history_entry.dart';
import '../entities/task.dart';
import '../entities/task_category.dart';

abstract interface class TasksRepository {
  Stream<List<Task>> watchTasks();
  Future<List<ActivityHistoryEntry>> getHistory();
  Future<Task?> getById(String id);
  Future<Task> create({
    required String title,
    String? description,
    required List<String> stepLabels,
    DateTime? reminderAt,
    TaskCategory category,
  });
  Future<Task> update(Task task);
  Future<void> delete(String id);
  Future<ActivityHistoryEntry> completeTask(String id);
  Future<Task> saveProgress(Task task);
}
