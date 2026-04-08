import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:flutter/material.dart';

List<String> normalizedTaskStepLabels(
  List<TextEditingController> controllers,
) {
  return controllers
      .map((controller) => controller.text.trim())
      .where((label) => label.isNotEmpty)
      .toList();
}

List<TaskStep> buildUpdatedTaskSteps(
  Task originalTask,
  List<String> stepLabels,
) {
  final steps = <TaskStep>[];
  for (var index = 0; index < stepLabels.length; index++) {
    final existingStep = index < originalTask.steps.length
        ? originalTask.steps[index]
        : null;
    steps.add(
      TaskStep(
        id: existingStep?.id ?? '${originalTask.id}_step_$index',
        label: stepLabels[index],
        order: index,
        completed: existingStep?.completed ?? false,
      ),
    );
  }
  return steps;
}
