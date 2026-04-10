import 'dart:async';

import 'package:fiap_hackathon/core/result/result.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/activity_history_entry.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_status.dart';
import 'package:fiap_hackathon/features/activities/domain/repositories/tasks_repository.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/complete_task_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/create_task_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/delete_task_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/get_activity_history_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/refresh_tasks_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/save_task_progress_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/update_task_use_case.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/watch_tasks_use_case.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:fiap_hackathon/features/auth/domain/entities/user_profile.dart';
import 'package:fiap_hackathon/features/auth/domain/repositories/auth_repository.dart';
import 'package:fiap_hackathon/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:fiap_hackathon/features/auth/domain/usecases/watch_auth_state_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TasksController', () {
    late _FakeAuthRepository authRepository;
    late _FakeTasksRepository tasksRepository;
    late TasksController controller;

    setUp(() {
      authRepository = _FakeAuthRepository(
        initialUser: const UserProfile(uid: 'user-a', email: 'a@test.com'),
      );
      tasksRepository = _FakeTasksRepository(authRepository)
        ..seedTasks('user-a', [_task(id: 'task-a', title: 'Tarefa A')])
        ..seedTasks('user-b', [_task(id: 'task-b', title: 'Tarefa B')])
        ..seedHistory(
          'user-b',
          [
            ActivityHistoryEntry(
              id: 'history-b',
              taskId: 'task-b',
              taskTitle: 'Concluida B',
              completedAt: DateTime(2026, 4, 9, 10),
              positiveMessage: 'Boa',
            ),
          ],
        );

      controller = TasksController(
        watchTasksUseCase: WatchTasksUseCase(tasksRepository),
        createTaskUseCase: CreateTaskUseCase(tasksRepository),
        updateTaskUseCase: UpdateTaskUseCase(tasksRepository),
        deleteTaskUseCase: DeleteTaskUseCase(tasksRepository),
        completeTaskUseCase: CompleteTaskUseCase(tasksRepository),
        getActivityHistoryUseCase: GetActivityHistoryUseCase(tasksRepository),
        saveTaskProgressUseCase: SaveTaskProgressUseCase(tasksRepository),
        refreshTasksUseCase: RefreshTasksUseCase(tasksRepository),
        getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
        watchAuthStateUseCase: WatchAuthStateUseCase(authRepository),
      );
    });

    tearDown(() async {
      controller.dispose();
      await tasksRepository.dispose();
      await authRepository.dispose();
    });

    test('reloads data when session user changes and clears on sign out', () async {
      await _settle();

      expect(controller.tasks.map((task) => task.title), ['Tarefa A']);
      expect(controller.history, isEmpty);

      authRepository.emit(const UserProfile(uid: 'user-b', email: 'b@test.com'));
      await _settle();

      expect(controller.tasks.map((task) => task.title), ['Tarefa B']);
      expect(controller.history.map((entry) => entry.taskTitle), ['Concluida B']);

      authRepository.emit(null);
      await _settle();

      expect(controller.tasks, isEmpty);
      expect(controller.history, isEmpty);
    });
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Task _task({required String id, required String title}) {
  final now = DateTime(2026, 4, 9, 9);
  return Task(
    id: id,
    title: title,
    steps: const [],
    status: TaskStatus.pending,
    category: TaskCategory.health,
    createdAt: now,
    updatedAt: now,
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({UserProfile? initialUser}) : _currentUser = initialUser;

  final _controller = StreamController<UserProfile?>.broadcast();
  UserProfile? _currentUser;

  void emit(UserProfile? user) {
    _currentUser = user;
    _controller.add(user);
  }

  Future<void> dispose() => _controller.close();

  @override
  bool get isSignedIn => _currentUser != null;

  @override
  UserProfile? get currentUser => _currentUser;

  @override
  Stream<UserProfile?> get authStateChanges => _controller.stream;

  @override
  Future<Result<void>> enter({
    required String email,
    required String password,
  }) async => const Success<void>(null);

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) async => const Success<void>(null);

  @override
  Future<Result<void>> enterWithGoogle() async => const Success<void>(null);

  @override
  Future<Result<void>> signOut() async => const Success<void>(null);
}

class _FakeTasksRepository implements TasksRepository {
  _FakeTasksRepository(this._authRepository);

  final _tasksController = StreamController<List<Task>>.broadcast();
  final _tasksByUser = <String, List<Task>>{};
  final _historyByUser = <String, List<ActivityHistoryEntry>>{};
  final _FakeAuthRepository _authRepository;

  void seedTasks(String uid, List<Task> tasks) {
    _tasksByUser[uid] = List<Task>.from(tasks);
  }

  void seedHistory(String uid, List<ActivityHistoryEntry> entries) {
    _historyByUser[uid] = List<ActivityHistoryEntry>.from(entries);
  }

  Future<void> dispose() => _tasksController.close();

  String get _uid {
    final uid = _authRepository.currentUser?.uid;
    if (uid == null) {
      throw StateError('Usuário não autenticado');
    }
    return uid;
  }

  @override
  Stream<List<Task>> watchTasks() => _tasksController.stream;

  @override
  Future<List<ActivityHistoryEntry>> getHistory() async {
    final uid = _authRepository.currentUser?.uid;
    if (uid == null) return [];
    return List<ActivityHistoryEntry>.from(_historyByUser[uid] ?? const []);
  }

  @override
  Future<Task?> getById(String id) async {
    final tasks = _tasksByUser[_uid] ?? const [];
    for (final task in tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  @override
  Future<Task> create({
    required String title,
    String? description,
    required List<String> stepLabels,
    DateTime? reminderAt,
    TaskCategory category = TaskCategory.health,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Task> update(Task task) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<ActivityHistoryEntry> completeTask(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Task> saveProgress(Task task) {
    throw UnimplementedError();
  }

  @override
  Future<void> refreshTasks() async {
    final uid = _authRepository.currentUser?.uid;
    final tasks = uid == null ? const <Task>[] : (_tasksByUser[uid] ?? const []);
    _tasksController.add(List<Task>.from(tasks));
  }
}
