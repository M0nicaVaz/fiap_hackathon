import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/task_row_actions.dart';
import 'package:flutter/material.dart';

class PendingTasksTable extends StatelessWidget {
  const PendingTasksTable({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
    required this.formatReminder,
    required this.progressText,
  });

  final List<Task> tasks;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;
  final String Function(DateTime) formatReminder;
  final String Function(Task) progressText;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (!width.isFinite || width <= 0) {
          return const SizedBox.shrink();
        }
        const minTableWidth = 720.0;
        final tableWidth = width < minTableWidth ? minTableWidth : width;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1.15),
                2: FlexColumnWidth(1.1),
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: ds.colors.disabled.withValues(alpha: 0.2),
                ),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: ds.colors.background),
                  children: [
                    _HeaderCell(label: 'TAREFA'),
                    _HeaderCell(label: 'HORÁRIO'),
                    _HeaderCell(label: 'AÇÕES', align: TextAlign.end),
                  ],
                ),
                ...tasks.map((task) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(ds.spacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: ds.spacing.xs / 2,
                                  ),
                                  child: Icon(
                                    taskCategoryIcon(task.category),
                                    size: ds.icons.sm,
                                    color: ds.colors.primary,
                                  ),
                                ),
                                SizedBox(width: ds.spacing.xs),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    softWrap: true,
                                    textWidthBasis: TextWidthBasis.parent,
                                    style: ds.typography.headingMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (task.description != null &&
                                task.description!.isNotEmpty) ...[
                              SizedBox(height: ds.spacing.xs),
                              Text(
                                task.description!,
                                softWrap: true,
                                textWidthBasis: TextWidthBasis.parent,
                                style: ds.typography.bodyMedium.copyWith(
                                  color: ds.colors.textSecondary,
                                ),
                              ),
                            ],
                            SizedBox(height: ds.spacing.xs),
                            Text(
                              progressText(task),
                              softWrap: true,
                              textWidthBasis: TextWidthBasis.parent,
                              style: ds.typography.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ds.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ds.spacing.lg),
                        child: task.reminderAt != null
                            ? LayoutTimePill(
                                label: formatReminder(task.reminderAt!),
                              )
                            : Text(
                                '—',
                                style: ds.typography.bodyMedium.copyWith(
                                  color: ds.colors.textSecondary,
                                ),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ds.spacing.md),
                        child: TaskRowActions(
                          task: task,
                          onEdit: onEdit,
                          onDelete: onDelete,
                          onWizard: onWizard,
                          onComplete: onComplete,
                          layout: TaskRowActionsLayout.desktop,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    this.align = TextAlign.start,
  });

  final String label;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Padding(
      padding: EdgeInsets.all(ds.spacing.lg),
      child: Text(
        label,
        textAlign: align,
        style: ds.typography.caption.copyWith(
          fontWeight: FontWeight.w800,
          color: ds.colors.textSecondary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
