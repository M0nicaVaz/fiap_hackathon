import 'package:fiap_hackathon/features/activities/domain/entities/activity_history_entry.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_status.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:fiap_hackathon/features/activities/domain/repositories/tasks_repository.dart';
import 'package:fiap_hackathon/features/activities/domain/services/completion_feedback_messages.dart';

class FakeTasksRepository implements TasksRepository {
  final List<Task> tasks = [];
  final List<ActivityHistoryEntry> history = [];
  int _seq = 0;

  String _newId() => 'id-${_seq++}';

  @override
  Stream<List<Task>> watchTasks() => Stream.value(List.unmodifiable(tasks));

  @override
  Future<List<ActivityHistoryEntry>> getHistory() async => List.from(history);

  @override
  Future<Task?> getById(String id) async {
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
    final id = _newId();
    final steps = <TaskStep>[];
    for (var i = 0; i < stepLabels.length; i++) {
      final label = stepLabels[i].trim();
      if (label.isEmpty) continue;
      steps.add(TaskStep(id: _newId(), label: label, order: i));
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
    tasks.add(task);
    return task;
  }

  @override
  Future<Task> update(Task task) async {
    final i = tasks.indexWhere((t) => t.id == task.id);
    if (i < 0) throw StateError('Tarefa não encontrada');
    tasks[i] = task;
    return task;
  }

  @override
  Future<void> delete(String id) async {
    tasks.removeWhere((t) => t.id == id);
  }

  @override
  Future<ActivityHistoryEntry> completeTask(String id) async {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index < 0) throw StateError('Tarefa não encontrada');
    final task = tasks.removeAt(index);
    final entry = ActivityHistoryEntry(
      id: _newId(),
      taskId: task.id,
      taskTitle: task.title,
      completedAt: DateTime.now(),
      positiveMessage:
          CompletionFeedbackMessages.forHistoryIndex(history.length),
    );
    history.insert(0, entry);
    return entry;
  }

  @override
  Future<Task> saveProgress(Task task) async {
    final i = tasks.indexWhere((t) => t.id == task.id);
    if (i < 0) throw StateError('Tarefa não encontrada');
    var next = task.copyWith(updatedAt: DateTime.now());
    if (next.steps.isNotEmpty) {
      final anyDone = next.steps.any((s) => s.completed);
      next = next.copyWith(
        status: anyDone ? TaskStatus.inProgress : TaskStatus.pending,
      );
    }
    tasks[i] = next;
    return next;
  }
}
