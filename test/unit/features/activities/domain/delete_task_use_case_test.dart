import 'package:fiap_hackathon/features/activities/domain/usecases/delete_task_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_tasks_repository.dart';

void main() {
  group('DeleteTaskUseCase', () {
    test('remove tarefa pelo id', () async {
      final repo = FakeTasksRepository();
      final created = await repo.create(
        title: 'X',
        stepLabels: const [],
      );
      final useCase = DeleteTaskUseCase(repo);

      await useCase(created.id);

      expect(repo.tasks, isEmpty);
    });
  });
}
