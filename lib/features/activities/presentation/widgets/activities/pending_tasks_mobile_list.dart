import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/task_row_actions.dart';
import 'package:flutter/material.dart';

class PendingTasksMobileList extends StatelessWidget {
  const PendingTasksMobileList({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
    required this.formatReminder,
    this.busyTaskId,
  });

  final List<Task> tasks;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;
  final String Function(DateTime) formatReminder;
  final String? busyTaskId;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(ds.spacing.md),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => SizedBox(height: ds.spacing.md),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final timeLabel = task.reminderAt != null
            ? formatReminder(task.reminderAt!)
            : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutTaskCardRow(
              title: task.title,
              subtitle: task.description,
              timeLabel: timeLabel,
              categoryIcon: taskCategoryIcon(task.category),
              onEdit: () => onEdit(task),
              onDelete: () => onDelete(task),
              onOpenGuide: task.steps.isNotEmpty ? () => onWizard(task) : null,
            ),
            SizedBox(height: ds.spacing.sm),
            TaskRowActions(
              task: task,
              onEdit: onEdit,
              onDelete: onDelete,
              onWizard: onWizard,
              onComplete: onComplete,
              layout: TaskRowActionsLayout.mobile,
              isBusy: busyTaskId == task.id,
            ),
          ],
        );
      },
    );
  }
}
