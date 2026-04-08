import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon_button/ds_icon_button.dart';
import 'package:flutter/material.dart';

class TaskStepsSection extends StatelessWidget {
  const TaskStepsSection({
    super.key,
    required this.expanded,
    required this.controllers,
    required this.onToggle,
    required this.onAddStep,
    required this.onRemoveStep,
  });

  final bool expanded;
  final List<TextEditingController> controllers;
  final VoidCallback onToggle;
  final VoidCallback onAddStep;
  final ValueChanged<int> onRemoveStep;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ds.spacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Etapas do guia (opcional)',
                        style: ds.typography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Cada etapa aparece no assistente, uma de cada vez.',
                        style: ds.typography.bodyMedium.copyWith(
                          color: ds.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: ds.colors.primary,
                ),
              ],
            ),
          ),
        ),
        if (expanded) ...[
          SizedBox(height: ds.spacing.md),
          ...List.generate(controllers.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: ds.spacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],
                      style: ds.typography.bodyLarge.copyWith(
                        color: ds.colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Etapa ${index + 1}',
                        filled: true,
                        fillColor: ds.colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ds.spacing.sm),
                  DSIconButton(
                    tooltip: 'Remover',
                    icon: Icons.remove_circle_outline,
                    iconColor: ds.colors.feedbackDanger,
                    onPressed: () => onRemoveStep(index),
                  ),
                ],
              ),
            );
          }),
          DSButton(
            label: 'Adicionar etapa',
            icon: Icons.add,
            variant: DSButtonVariant.secondary,
            fullWidth: true,
            onPressed: onAddStep,
          ),
          SizedBox(height: ds.spacing.xxl),
        ],
      ],
    );
  }
}
