import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskCategoryLabel', () {
    test('rótulos em português', () {
      expect(TaskCategory.health.labelPt, 'Saúde');
      expect(TaskCategory.social.labelPt, 'Social');
      expect(TaskCategory.exercise.labelPt, 'Exercício');
      expect(TaskCategory.chores.labelPt, 'Outros');
    });
  });
}
