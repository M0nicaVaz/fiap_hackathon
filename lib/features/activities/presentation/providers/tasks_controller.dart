import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../../auth/domain/usecases/get_current_user_use_case.dart';
import '../../../auth/domain/usecases/watch_auth_state_use_case.dart';
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
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required WatchAuthStateUseCase watchAuthStateUseCase,
  }) : _watchTasksUseCase = watchTasksUseCase,
       _createTaskUseCase = createTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _completeTaskUseCase = completeTaskUseCase,
       _getActivityHistoryUseCase = getActivityHistoryUseCase,
       _saveTaskProgressUseCase = saveTaskProgressUseCase,
       _refreshTasksUseCase = refreshTasksUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _watchAuthStateUseCase = watchAuthStateUseCase {
    _subscription = _watchTasksUseCase().listen((list) {
      _tasks = list;
      _tasksView = UnmodifiableListView(_tasks);
      notifyListeners();
    });
    _bootstrap();
  }

  final WatchTasksUseCase _watchTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final GetActivityHistoryUseCase _getActivityHistoryUseCase;
  final SaveTaskProgressUseCase _saveTaskProgressUseCase;
  final RefreshTasksUseCase _refreshTasksUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final WatchAuthStateUseCase _watchAuthStateUseCase;
  StreamSubscription<List<Task>>? _subscription;
  StreamSubscription<UserProfile?>? _authSubscription;
  List<Task> _tasks = [];
  List<ActivityHistoryEntry> _history = [];
  String? _loadedTasksForUid;
  late UnmodifiableListView<Task> _tasksView = UnmodifiableListView(_tasks);
  late UnmodifiableListView<ActivityHistoryEntry> _historyView =
      UnmodifiableListView(_history);
  final Set<String> _dismissedReminderIds = {};
  List<Task> get tasks => _tasksView;
  List<ActivityHistoryEntry> get history => _historyView;

  void _bootstrap() {
    _onAuthChanged(_getCurrentUserUseCase());
    _authSubscription = _watchAuthStateUseCase().listen(_onAuthChanged);
  }

  void _onAuthChanged(UserProfile? user) {
    final uid = user?.uid;
    if (uid == null) {
      _loadedTasksForUid = null;
      _clearState();
      return;
    }
    if (_loadedTasksForUid == uid) return;
    _loadedTasksForUid = uid;
    _dismissedReminderIds.clear();
    unawaited(_reloadCurrentUserData());
  }

  Future<void> _reloadCurrentUserData() async {
    await _refreshTasksUseCase();
    await loadHistory();
  }

  void _clearState() {
    _dismissedReminderIds.clear();
    _tasks = [];
    _history = [];
    _tasksView = UnmodifiableListView(_tasks);
    _historyView = UnmodifiableListView(_history);
    notifyListeners();
  }

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
    unawaited(_authSubscription?.cancel());
    super.dispose();
  }
}
