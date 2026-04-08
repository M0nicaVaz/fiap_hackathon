import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/pages/task_editor_page.dart';
import 'package:fiap_hackathon/features/activities/presentation/pages/task_wizard_page.dart';
import 'package:flutter/material.dart';

Future<void> openTaskEditor(
  BuildContext context, {
  Task? task,
}) async {
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => TaskEditorPage(initialTask: task),
    ),
  );
}

Future<void> openTaskWizard(
  BuildContext context,
  Task task,
) async {
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => TaskWizardPage(taskId: task.id),
    ),
  );
}
