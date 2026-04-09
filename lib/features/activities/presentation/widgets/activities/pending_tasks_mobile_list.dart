import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_status.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/activities_dialogs.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:fiap_hackathon/features/accessibility_preferences/presentation/providers/accessibility_preferences_controller.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

        return Consumer<AccessibilityPreferencesController>(
          builder: (context, access, _) {
            final reinforced = access.reinforcedFeedback;
            final canOpenWizard = task.steps.isNotEmpty;
            final canComplete = task.steps.isEmpty ||
                task.steps.every((step) => step.completed);

            return LayoutTaskCardRow(
              title: task.title,
              subtitle: task.description,
              timeLabel: timeLabel,
              categoryIcon: taskCategoryIcon(task.category),
              onEdit: () => onEdit(task),
              onDelete: () => onDelete(task),
              onOpenGuide: canOpenWizard ? () => onWizard(task) : null,
              trailing: IconButton(
                onPressed: busyTaskId == task.id
                    ? null
                    : () => showTaskActionMenuDialog(
                          context: context,
                          title: task.title,
                          onEdit: () => onEdit(task),
                          onDelete: () => onDelete(task),
                          onWizard: canOpenWizard ? () => onWizard(task) : null,
                          onComplete:
                              canComplete ? () => onComplete(task) : null,
                        ),
                style: IconButton.styleFrom(
                  backgroundColor: reinforced ? ds.colors.primary : null,
                  foregroundColor:
                      reinforced ? ds.colors.primaryInverse : ds.colors.primary,
                  side: reinforced
                      ? BorderSide(color: ds.colors.primary, width: 2)
                      : null,
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.menu),
                visualDensity: VisualDensity.comfortable,
              ),
            );
          },
        );
      },
    );
  }
}
