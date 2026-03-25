import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/domain/usecases/create_task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_tasks_repository.dart';

void main() {
  group('CreateTaskUseCase', () {
    test('cria tarefa via repositório', () async {
      final repo = FakeTasksRepository();
      final useCase = CreateTaskUseCase(repo);

      final task = await useCase(
        title: '  Estudar  ',
        description: ' Flutter ',
        stepLabels: const ['Passo 1', '', '  Passo 2  '],
        category: TaskCategory.exercise,
      );

      expect(task.title, 'Estudar');
      expect(task.description, 'Flutter');
      expect(task.category, TaskCategory.exercise);
      expect(task.steps.length, 2);
      expect(repo.tasks.length, 1);
    });
  });
}
