import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/shared_preferences_tasks_local_data_source.dart';
import '../data/datasources/tasks_local_data_source.dart';
import '../data/repositories/tasks_repository_impl.dart';
import '../domain/repositories/tasks_repository.dart';
import '../domain/usecases/complete_task_use_case.dart';
import '../domain/usecases/create_task_use_case.dart';
import '../domain/usecases/delete_task_use_case.dart';
import '../domain/usecases/get_activity_history_use_case.dart';
import '../domain/usecases/save_task_progress_use_case.dart';
import '../domain/usecases/update_task_use_case.dart';
import '../domain/usecases/watch_tasks_use_case.dart';
import '../presentation/providers/tasks_controller.dart';

TasksController createTasksController(SharedPreferences prefs) {
  final TasksLocalDataSource dataSource =
      SharedPreferencesTasksLocalDataSource(prefs);
  final TasksRepository repository = TasksRepositoryImpl(dataSource);

  return TasksController(
    watchTasksUseCase: WatchTasksUseCase(repository),
    createTaskUseCase: CreateTaskUseCase(repository),
    updateTaskUseCase: UpdateTaskUseCase(repository),
    deleteTaskUseCase: DeleteTaskUseCase(repository),
    completeTaskUseCase: CompleteTaskUseCase(repository),
    getActivityHistoryUseCase: GetActivityHistoryUseCase(repository),
    saveTaskProgressUseCase: SaveTaskProgressUseCase(repository),
  );
}
