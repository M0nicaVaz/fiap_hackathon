import '../../domain/entities/activity_history_entry.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/entities/task_step.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../domain/services/completion_feedback_messages.dart';
import '../datasources/tasks_local_data_source.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl(this._dataSource);

  final TasksLocalDataSource _dataSource;

  @override
  Stream<List<Task>> watchTasks() => _dataSource.tasksStream;

  @override
  Future<List<ActivityHistoryEntry>> getHistory() => _dataSource.loadHistory();

  @override
  Future<Task?> getById(String id) async {
    final tasks = await _dataSource.loadTasks();
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Task> create({
    required String title,
    String? description,
    required List<String> stepLabels,
    DateTime? reminderAt,
    TaskCategory category = TaskCategory.health,
  }) async {
    final now = DateTime.now();
    final id = _dataSource.newId();
    final steps = <TaskStep>[];
    for (var i = 0; i < stepLabels.length; i++) {
      final label = stepLabels[i].trim();
      if (label.isEmpty) continue;
      steps.add(
        TaskStep(
          id: _dataSource.newId(),
          label: label,
          order: i,
        ),
      );
    }
    final task = Task(
      id: id,
      title: title.trim(),
      description: description?.trim().isEmpty ?? true
          ? null
          : description!.trim(),
      steps: steps,
      status: TaskStatus.pending,
      category: category,
      reminderAt: reminderAt,
      createdAt: now,
      updatedAt: now,
    );
    final tasks = await _dataSource.loadTasks();
    tasks.add(task);
    await _dataSource.saveTasks(tasks);
    return task;
  }

  @override
  Future<Task> update(Task task) async {
    final tasks = await _dataSource.loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      throw StateError('Tarefa não encontrada');
    }
    final updated = task.copyWith(updatedAt: DateTime.now());
    tasks[index] = updated;
    await _dataSource.saveTasks(tasks);
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    final tasks = await _dataSource.loadTasks();
    tasks.removeWhere((t) => t.id == id);
    await _dataSource.saveTasks(tasks);
  }

  @override
  Future<ActivityHistoryEntry> completeTask(String id) async {
    final tasks = await _dataSource.loadTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index < 0) {
      throw StateError('Tarefa não encontrada');
    }
    final task = tasks[index];
    final history = await _dataSource.loadHistory();
    final entry = ActivityHistoryEntry(
      id: _dataSource.newId(),
      taskId: task.id,
      taskTitle: task.title,
      completedAt: DateTime.now(),
      positiveMessage:
          CompletionFeedbackMessages.forHistoryIndex(history.length),
    );
    history.insert(0, entry);
    tasks.removeAt(index);
    await _dataSource.saveHistory(history);
    await _dataSource.saveTasks(tasks);
    return entry;
  }

  @override
  Future<Task> saveProgress(Task task) async {
    final tasks = await _dataSource.loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      throw StateError('Tarefa não encontrada');
    }
    var next = task.copyWith(updatedAt: DateTime.now());
    if (next.steps.isNotEmpty) {
      final anyDone = next.steps.any((s) => s.completed);
      next = next.copyWith(
        status: anyDone ? TaskStatus.inProgress : TaskStatus.pending,
      );
    }
    tasks[index] = next;
    await _dataSource.saveTasks(tasks);
    return next;
  }
}
