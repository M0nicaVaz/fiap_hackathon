import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_status.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime(2025, 1, 1);

  Task buildTask({
    List<TaskStep>? steps,
    TaskStatus status = TaskStatus.pending,
  }) {
    return Task(
      id: '1',
      title: 'Título',
      steps: steps ?? const [],
      status: status,
      createdAt: t0,
      updatedAt: t0,
      category: TaskCategory.social,
    );
  }

  group('Task', () {
    test('hasSteps é false quando não há passos', () {
      expect(buildTask(steps: const []).hasSteps, isFalse);
    });

    test('hasSteps é true quando há passos', () {
      expect(
        buildTask(
          steps: const [
            TaskStep(id: 's1', label: 'A', order: 0),
          ],
        ).hasSteps,
        isTrue,
      );
    });

    test('completedStepsCount conta passos concluídos', () {
      final task = buildTask(
        steps: const [
          TaskStep(id: 'a', label: '1', order: 0, completed: true),
          TaskStep(id: 'b', label: '2', order: 1, completed: false),
          TaskStep(id: 'c', label: '3', order: 2, completed: true),
        ],
      );
      expect(task.completedStepsCount, 2);
    });

    test('copyWith altera apenas os campos informados', () {
      final original = buildTask();
      final next = original.copyWith(title: 'Novo', status: TaskStatus.inProgress);
      expect(next.title, 'Novo');
      expect(next.status, TaskStatus.inProgress);
      expect(next.id, original.id);
      expect(next.category, original.category);
    });
  });
}
