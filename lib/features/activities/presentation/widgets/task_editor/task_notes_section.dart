import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/task_editor_input_decorations.dart';
import 'package:flutter/material.dart';

class TaskNotesSection extends StatelessWidget {
  const TaskNotesSection({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Observações (opcional)',
          style: ds.typography.bodyLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: ds.spacing.sm),
        TextFormField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          style: ds.typography.bodyLarge.copyWith(
            color: ds.colors.textPrimary,
          ),
          decoration: buildTaskEditorNotesDecoration(ds),
        ),
      ],
    );
  }
}
