import 'package:fiap_hackathon/features/activities/domain/usecases/complete_task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_tasks_repository.dart';

void main() {
  group('CompleteTaskUseCase', () {
    test('conclui tarefa e retorna entrada de histórico', () async {
      final repo = FakeTasksRepository();
      final task = await repo.create(
        title: 'Comprar',
        stepLabels: const [],
      );
      final useCase = CompleteTaskUseCase(repo);

      final entry = await useCase(task.id);

      expect(entry.taskId, task.id);
      expect(entry.taskTitle, task.title);
      expect(repo.tasks, isEmpty);
      expect(repo.history.length, 1);
    });
  });
}
