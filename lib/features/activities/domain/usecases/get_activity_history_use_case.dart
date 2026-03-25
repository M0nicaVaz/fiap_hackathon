import '../entities/activity_history_entry.dart';
import '../repositories/tasks_repository.dart';

class GetActivityHistoryUseCase {
  GetActivityHistoryUseCase(this._repository);
  final TasksRepository _repository;
  Future<List<ActivityHistoryEntry>> call() => _repository.getHistory();
}
