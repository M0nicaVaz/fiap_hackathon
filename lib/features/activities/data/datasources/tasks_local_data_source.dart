import '../../domain/entities/activity_history_entry.dart';
import '../../domain/entities/task.dart';

abstract interface class TasksLocalDataSource {
  Stream<List<Task>> get tasksStream;
  Future<void> emitCurrent();
  Future<List<Task>> loadTasks();
  Future<void> saveTasks(List<Task> tasks);
  Future<List<ActivityHistoryEntry>> loadHistory();
  Future<void> saveHistory(List<ActivityHistoryEntry> entries);
  String newId();
}
