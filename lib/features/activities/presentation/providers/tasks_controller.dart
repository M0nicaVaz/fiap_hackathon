import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../../domain/entities/activity_history_entry.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';
import '../../domain/usecases/complete_task_use_case.dart';
import '../../domain/usecases/create_task_use_case.dart';
import '../../domain/usecases/delete_task_use_case.dart';
import '../../domain/usecases/get_activity_history_use_case.dart';
import '../../domain/usecases/save_task_progress_use_case.dart';
import '../../domain/usecases/update_task_use_case.dart';
import '../../domain/usecases/watch_tasks_use_case.dart';
import '../../domain/usecases/refresh_tasks_use_case.dart';

class TasksController extends ChangeNotifier {
  TasksController({
    required WatchTasksUseCase watchTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required CompleteTaskUseCase completeTaskUseCase,
    required GetActivityHistoryUseCase getActivityHistoryUseCase,
    required SaveTaskProgressUseCase saveTaskProgressUseCase,
    required RefreshTasksUseCase refreshTasksUseCase,
  }) : _watchTasksUseCase = watchTasksUseCase,
       _createTaskUseCase = createTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _completeTaskUseCase = completeTaskUseCase,
       _getActivityHistoryUseCase = getActivityHistoryUseCase,
       _saveTaskProgressUseCase = saveTaskProgressUseCase,
       _refreshTasksUseCase = refreshTasksUseCase {
    _subscription = _watchTasksUseCase().listen((list) {
      _tasks = list;
      _tasksView = UnmodifiableListView(_tasks);
      notifyListeners();
    });
    refreshTasks();
  }

  final WatchTasksUseCase _watchTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final GetActivityHistoryUseCase _getActivityHistoryUseCase;
  final SaveTaskProgressUseCase _saveTaskProgressUseCase;
  final RefreshTasksUseCase _refreshTasksUseCase;
  StreamSubscription<List<Task>>? _subscription;
  List<Task> _tasks = [];
  List<ActivityHistoryEntry> _history = [];
  late UnmodifiableListView<Task> _tasksView = UnmodifiableListView(_tasks);
  late UnmodifiableListView<ActivityHistoryEntry> _historyView =
      UnmodifiableListView(_history);
  final Set<String> _dismissedReminderIds = {};
  List<Task> get tasks => _tasksView;
  List<ActivityHistoryEntry> get history => _historyView;
  Task? taskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Task> get dueReminders {
    final now = DateTime.now();
    return _tasks.where((t) {
      final r = t.reminderAt;
      if (r == null) return false;
      if (_dismissedReminderIds.contains(t.id)) return false;
      return !r.isAfter(now);
    }).toList();
  }

  Future<void> loadHistory() async {
    _history = await _getActivityHistoryUseCase();
    _historyView = UnmodifiableListView(_history);
    notifyListeners();
  }

  void dismissReminder(String taskId) {
    _dismissedReminderIds.add(taskId);
    notifyListeners();
  }

  Future<Task> createTask({
    required String title,
    String? description,
    required List<String> stepLabels,
    DateTime? reminderAt,
    TaskCategory category = TaskCategory.health,
  }) {
    return _createTaskUseCase(
      title: title,
      description: description,
      stepLabels: stepLabels,
      reminderAt: reminderAt,
      category: category,
    );
  }

  Future<void> updateTask(Task task) => _updateTaskUseCase(task);
  Future<void> deleteTask(String id) => _deleteTaskUseCase(id);
  Future<ActivityHistoryEntry> completeTask(String id) =>
      _completeTaskUseCase(id);
  Future<Task> saveProgress(Task task) => _saveTaskProgressUseCase(task);

  Future<void> refreshTasks() async {
    await _refreshTasksUseCase();
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
