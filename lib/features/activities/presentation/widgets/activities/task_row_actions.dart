import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_status.dart';
import 'package:flutter/material.dart';

enum TaskRowActionsLayout {
  desktop,
  mobile,
}

class TaskRowActions extends StatelessWidget {
  const TaskRowActions({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
    required this.layout,
  });

  final Task task;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;
  final TaskRowActionsLayout layout;

  bool get _canOpenWizard => task.steps.isNotEmpty;
  bool get _canComplete =>
      task.steps.isEmpty || task.steps.every((step) => step.completed);

  @override
  Widget build(BuildContext context) {
    return switch (layout) {
      TaskRowActionsLayout.desktop => _TaskDesktopActions(
          task: task,
          canOpenWizard: _canOpenWizard,
          canComplete: _canComplete,
          onEdit: onEdit,
          onDelete: onDelete,
          onWizard: onWizard,
          onComplete: onComplete,
        ),
      TaskRowActionsLayout.mobile => _TaskMobileActions(
          task: task,
          canOpenWizard: _canOpenWizard,
          canComplete: _canComplete,
          onEdit: onEdit,
          onDelete: onDelete,
          onWizard: onWizard,
          onComplete: onComplete,
        ),
    };
  }
}

class _TaskDesktopActions extends StatelessWidget {
  const _TaskDesktopActions({
    required this.task,
    required this.canOpenWizard,
    required this.canComplete,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
  });

  final Task task;
  final bool canOpenWizard;
  final bool canComplete;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 4,
      children: [
        if (canOpenWizard)
          IconButton(
            onPressed: () => onWizard(task),
            icon: const Icon(Icons.route),
            tooltip: 'Guia',
          ),
        if (canComplete)
          IconButton(
            onPressed: () => onComplete(task),
            icon: const Icon(Icons.celebration_outlined),
            tooltip: 'Concluir',
          ),
        IconButton(
          onPressed: () => onEdit(task),
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Editar',
        ),
        IconButton(
          onPressed: () => onDelete(task),
          icon: Icon(
            Icons.delete_outline,
            color: context.ds.colors.feedbackDanger,
          ),
          tooltip: 'Excluir',
        ),
      ],
    );
  }
}

class _TaskMobileActions extends StatelessWidget {
  const _TaskMobileActions({
    required this.task,
    required this.canOpenWizard,
    required this.canComplete,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
  });

  final Task task;
  final bool canOpenWizard;
  final bool canComplete;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;

  @override
  Widget build(BuildContext context) {
    final gap = context.ds.spacing.sm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canOpenWizard) ...[
          DSButton(
            label: task.status == TaskStatus.inProgress
                ? 'Continuar guia'
                : 'Abrir guia passo a passo',
            icon: Icons.route,
            fullWidth: true,
            onPressed: () => onWizard(task),
          ),
          SizedBox(height: gap),
        ],
        if (canComplete) ...[
          DSButton(
            label: 'Concluir atividade',
            icon: Icons.celebration,
            fullWidth: true,
            onPressed: () => onComplete(task),
          ),
          SizedBox(height: gap),
        ],
        DSButton(
          label: 'Editar',
          icon: Icons.edit,
          variant: DSButtonVariant.secondary,
          fullWidth: true,
          onPressed: () => onEdit(task),
        ),
        SizedBox(height: gap),
        DSButton(
          label: 'Excluir',
          icon: Icons.delete_outline,
          variant: DSButtonVariant.danger,
          fullWidth: true,
          onPressed: () => onDelete(task),
        ),
      ],
    );
  }
}
