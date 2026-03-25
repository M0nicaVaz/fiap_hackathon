import '../entities/activity_history_entry.dart';
import '../repositories/tasks_repository.dart';

class CompleteTaskUseCase {
  CompleteTaskUseCase(this._repository);
  final TasksRepository _repository;
  Future<ActivityHistoryEntry> call(String id) => _repository.completeTask(id);
}
