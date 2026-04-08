import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class TaskEditorHeroCard extends StatelessWidget {
  const TaskEditorHeroCard({
    super.key,
    required this.isEditing,
  });

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Container(
      padding: EdgeInsets.all(ds.spacing.xl),
      decoration: BoxDecoration(
        color: ds.colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ds.colors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ds.spacing.md),
            decoration: BoxDecoration(
              color: ds.colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_task,
              color: ds.colors.primaryInverse,
              size: ds.icons.lg,
            ),
          ),
          SizedBox(width: ds.spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Editar atividade' : 'Criar nova atividade',
                  style: ds.typography.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: ds.spacing.xs),
                Text(
                  'Inclua uma nova atividade na sua rotina no SeniorEase.',
                  style: ds.typography.bodyLarge.copyWith(
                    color: ds.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
