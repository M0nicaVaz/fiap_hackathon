import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/pending_tasks_mobile_list.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/pending_tasks_table.dart';
import 'package:flutter/material.dart';

class PendingTasksSection extends StatelessWidget {
  const PendingTasksSection({
    super.key,
    required this.tasks,
    required this.isWide,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
    required this.formatReminder,
    required this.progressText,
  });

  final List<Task> tasks;
  final bool isWide;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;
  final String Function(DateTime) formatReminder;
  final String Function(Task) progressText;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    if (tasks.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(ds.spacing.xxl),
        child: Text(
          'Nenhuma atividade pendente.\nUse "Nova atividade" para criar.',
          textAlign: TextAlign.center,
          style: ds.typography.bodyLarge.copyWith(
            color: ds.colors.textSecondary,
            height: 1.45,
          ),
        ),
      );
    }
    if (isWide) {
      return PendingTasksTable(
        tasks: tasks,
        onEdit: onEdit,
        onDelete: onDelete,
        onWizard: onWizard,
        onComplete: onComplete,
        formatReminder: formatReminder,
        progressText: progressText,
      );
    }
    return PendingTasksMobileList(
      tasks: tasks,
      onEdit: onEdit,
      onDelete: onDelete,
      onWizard: onWizard,
      onComplete: onComplete,
      formatReminder: formatReminder,
    );
  }
}
