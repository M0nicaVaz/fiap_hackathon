import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class WatchTasksUseCase {
  WatchTasksUseCase(this._repository);
  final TasksRepository _repository;
  Stream<List<Task>> call() => _repository.watchTasks();
}
