import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('taskCategoryIcon expõe um ícone por categoria', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              for (final c in TaskCategory.values) Icon(taskCategoryIcon(c)),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsNWidgets(TaskCategory.values.length));
  });
}
