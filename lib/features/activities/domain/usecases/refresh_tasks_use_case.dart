import '../repositories/tasks_repository.dart';

class RefreshTasksUseCase {
  RefreshTasksUseCase(this._repository);
  final TasksRepository _repository;
  Future<void> call() => _repository.refreshTasks();
}
