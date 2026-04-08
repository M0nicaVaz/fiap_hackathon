import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/task_editor_input_decorations.dart';
import 'package:flutter/material.dart';

class TaskTitleSection extends StatelessWidget {
  const TaskTitleSection({
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
          'O que precisa ser feito?',
          style: ds.typography.bodyLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: ds.spacing.sm),
        TextFormField(
          controller: controller,
          style: ds.typography.bodyLarge.copyWith(
            color: ds.colors.textPrimary,
          ),
          decoration: buildTaskEditorStadiumFieldDecoration(
            ds,
            'Ex.: caminhada matinal ou tomar medicação',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe um título curto e claro.';
            }
            return null;
          },
        ),
      ],
    );
  }
}
