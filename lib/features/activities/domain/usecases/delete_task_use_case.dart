import '../repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  DeleteTaskUseCase(this._repository);
  final TasksRepository _repository;
  Future<void> call(String id) => _repository.delete(id);
}
