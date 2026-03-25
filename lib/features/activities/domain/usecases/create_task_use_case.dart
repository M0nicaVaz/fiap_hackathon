import '../entities/task.dart';
import '../entities/task_category.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase {
  CreateTaskUseCase(this._repository);
  final TasksRepository _repository;
  Future<Task> call({
    required String title,
    String? description,
    required List<String> stepLabels,
    DateTime? reminderAt,
    TaskCategory category = TaskCategory.health,
  }) {
    return _repository.create(
      title: title,
      description: description,
      stepLabels: stepLabels,
      reminderAt: reminderAt,
      category: category,
    );
  }
}
