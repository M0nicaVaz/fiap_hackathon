import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/activity_history_entry.dart';
import '../../domain/entities/task.dart';
import '../mappers/task_persistence_mapper.dart';
import 'tasks_local_data_source.dart';

class SharedPreferencesTasksLocalDataSource implements TasksLocalDataSource {
  SharedPreferencesTasksLocalDataSource(this._prefs) {
    loadTasks().then(_controller.add);
  }

  static const _keyTasks = 'activities_tasks_v2';
  static const _keyHistory = 'activities_history_v1';

  final SharedPreferences _prefs;

  final _controller = StreamController<List<Task>>.broadcast();

  @override
  Stream<List<Task>> get tasksStream => _controller.stream;

  @override
  Future<void> emitCurrent() async {
    _controller.add(await loadTasks());
  }

  @override
  Future<List<Task>> loadTasks() async {
    final raw = _prefs.getString(_keyTasks);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => TaskPersistenceMapper.taskFromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final encoded = jsonEncode(tasks.map(TaskPersistenceMapper.taskToMap).toList());
    await _prefs.setString(_keyTasks, encoded);
    _controller.add(tasks);
  }

  @override
  Future<List<ActivityHistoryEntry>> loadHistory() async {
    final raw = _prefs.getString(_keyHistory);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => TaskPersistenceMapper.historyEntryFromMap(
              e as Map<String, dynamic>,
            ))
        .toList();
  }

  @override
  Future<void> saveHistory(List<ActivityHistoryEntry> entries) async {
    final encoded =
        jsonEncode(entries.map(TaskPersistenceMapper.historyEntryToMap).toList());
    await _prefs.setString(_keyHistory, encoded);
  }

  @override
  String newId() {
    final r = Random();
    return '${DateTime.now().microsecondsSinceEpoch}_${r.nextInt(0x7fffffff)}';
  }
}
