import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  UpdateTaskUseCase(this._repository);
  final TasksRepository _repository;
  Future<Task> call(Task task) => _repository.update(task);
}
