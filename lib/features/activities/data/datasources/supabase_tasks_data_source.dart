import 'dart:async';
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/activity_history_entry.dart';
import '../../domain/entities/task.dart';
import '../mappers/task_persistence_mapper.dart';
import 'tasks_local_data_source.dart';

class SupabaseTasksDataSource implements TasksLocalDataSource {
  SupabaseTasksDataSource(this._client) {
    _init();
  }

  final SupabaseClient _client;
  final _random = Random();

  final _controller = StreamController<List<Task>>.broadcast();

  String? get _userId => _client.auth.currentUser?.id;

  Future<String> _requireUserId() async {
    final id = _userId;
    if (id != null) return id;
    final completer = Completer<String>();
    late StreamSubscription sub;
    sub = _client.auth.onAuthStateChange.listen((event) {
      final uid = event.session?.user.id;
      if (uid != null && !completer.isCompleted) {
        completer.complete(uid);
        sub.cancel();
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        completer.completeError('Usuário não autenticado');
        sub.cancel();
      }
    });
    return completer.future;
  }

  Future<void> _init() async {}

  @override
  Stream<List<Task>> get tasksStream => _controller.stream;

  @override
  Future<void> emitCurrent() async {
    final tasks = await loadTasks();
    _controller.add(tasks);
  }

  @override
  Future<List<Task>> loadTasks() async {
    final uid = await _requireUserId();
    final rows = await _client
        .from('tasks')
        .select()
        .eq('user_id', uid)
        .order('created_at');
    return rows
        .map((r) => TaskPersistenceMapper.taskFromMap(_rowToMap(r)))
        .toList();
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final uid = await _requireUserId();
    final currentIds = tasks.map((t) => t.id).toList();
    await _client
        .from('tasks')
        .delete()
        .eq('user_id', uid)
        .not('id', 'in', currentIds.isEmpty ? [''] : currentIds);
    if (tasks.isNotEmpty) {
      await _client
          .from('tasks')
          .upsert(tasks.map((t) => _taskToRow(t, uid)).toList());
    }
    _controller.add(tasks);
  }

  @override
  Future<List<ActivityHistoryEntry>> loadHistory() async {
    final uid = await _requireUserId();
    final rows = await _client
        .from('activity_history')
        .select()
        .eq('user_id', uid)
        .order('completed_at', ascending: false);
    return rows
        .map(
          (r) => TaskPersistenceMapper.historyEntryFromMap(_historyRowToMap(r)),
        )
        .toList();
  }

  @override
  Future<void> saveHistory(List<ActivityHistoryEntry> entries) async {
    final uid = await _requireUserId();
    await _client.from('activity_history').delete().eq('user_id', uid);
    if (entries.isNotEmpty) {
      await _client
          .from('activity_history')
          .insert(entries.map((e) => _historyToRow(e, uid)).toList());
    }
  }

  @override
  String newId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(0x7fffffff)}';

  Map<String, dynamic> _taskToRow(Task t, String uid) => {
    'id': t.id,
    'user_id': uid,
    'title': t.title,
    'description': t.description,
    'steps': t.steps.map(TaskPersistenceMapper.stepToMap).toList(),
    'status': t.status.index,
    'category': t.category.index,
    'reminder_at': t.reminderAt?.toUtc().toIso8601String(),
    'created_at': t.createdAt.toUtc().toIso8601String(),
    'updated_at': t.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _rowToMap(Map<String, dynamic> r) => {
    'id': r['id'],
    'title': r['title'],
    'description': r['description'],
    'steps': r['steps'],
    'status': r['status'],
    'category': r['category'],
    'reminderAt': r['reminder_at'],
    'createdAt': r['created_at'],
    'updatedAt': r['updated_at'],
  };

  Map<String, dynamic> _historyToRow(ActivityHistoryEntry e, String uid) => {
    'id': e.id,
    'user_id': uid,
    'task_id': e.taskId,
    'task_title': e.taskTitle,
    'completed_at': e.completedAt.toUtc().toIso8601String(),
    'positive_message': e.positiveMessage,
  };

  Map<String, dynamic> _historyRowToMap(Map<String, dynamic> r) => {
    'id': r['id'],
    'taskId': r['task_id'],
    'taskTitle': r['task_title'],
    'completedAt': r['completed_at'],
    'positiveMessage': r['positive_message'],
  };

  void dispose() {
    _controller.close();
  }
}
