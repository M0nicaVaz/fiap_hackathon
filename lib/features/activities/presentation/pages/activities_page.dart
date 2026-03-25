import 'dart:async';

import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/activity_history_entry.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_status.dart';
import 'package:fiap_hackathon/features/activities/presentation/pages/task_editor_page.dart';
import 'package:fiap_hackathon/features/activities/presentation/pages/task_wizard_page.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  Timer? _reminderTimer;
  int _tabIndex = 0;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasksController>().loadHistory();
      _tickReminders();
    });
    _reminderTimer = Timer.periodic(
      const Duration(seconds: 45),
      (_) => _tickReminders(),
    );
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _tickReminders() {
    if (!mounted) return;
    final controller = context.read<TasksController>();
    final due = controller.dueReminders;
    if (due.isEmpty) return;

    final ds = context.ds;
    final task = due.first;
    controller.dismissReminder(task.id);

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: ds.colors.surface,
        content: Text(
          'Lembrete: "${task.title}". Toque em "Abrir" para ver a atividade.',
          style: ds.typography.bodyMedium.copyWith(color: ds.colors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              _openWizard(context, task);
            },
            child: Text('Abrir', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: Text('Fechar', style: ds.typography.label),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final ds = context.ds;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: ds.colors.surface,
          title: Text(
            'Excluir atividade?',
            style: ds.typography.headingMedium,
          ),
          content: Text(
            'Esta ação não pode ser desfeita.',
            style: ds.typography.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancelar', style: ds.typography.label),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Excluir',
                style: ds.typography.label.copyWith(
                  color: ds.colors.feedbackDanger,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !context.mounted) return;
    await context.read<TasksController>().deleteTask(task.id);
    if (!context.mounted) return;
    _snack(context, 'Atividade removida.');
  }

  void _snack(BuildContext context, String message) {
    final ds = context.ds;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: ds.typography.bodyMedium),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {Task? task}) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (ctx) => TaskEditorPage(initialTask: task),
      ),
    );
  }

  Future<void> _openWizard(BuildContext context, Task task) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (ctx) => TaskWizardPage(taskId: task.id),
      ),
    );
  }

  Future<void> _confirmOpenWizard(BuildContext context, Task task) async {
    final ds = context.ds;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text(
          'Abrir assistente?',
          style: ds.typography.headingMedium,
        ),
        content: Text(
          'As etapas desta atividade serão mostradas uma a uma.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Abrir', style: ds.typography.label),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await _openWizard(context, task);
  }

  Future<void> _completeQuick(BuildContext context, Task task) async {
    final ds = context.ds;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text(
          'Concluir atividade?',
          style: ds.typography.headingMedium,
        ),
        content: Text(
          'Esta atividade será registrada como concluída e movida para o histórico.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Concluir', style: ds.typography.label),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final tasksController = context.read<TasksController>();
    final entry = await tasksController.completeTask(task.id);
    if (!context.mounted) return;
    await tasksController.loadHistory();
    if (!context.mounted) return;
    _snack(context, entry.positiveMessage);
  }

  List<Task> _filterTasks(List<Task> tasks, String q) {
    if (q.trim().isEmpty) return tasks;
    final s = q.trim().toLowerCase();
    return tasks.where((t) => t.title.toLowerCase().contains(s)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final tasks = context.watch<TasksController>().tasks;
    final history = context.watch<TasksController>().history;
    final filtered = _filterTasks(tasks, _searchController.text);

    return Scaffold(
      backgroundColor: ds.colors.background,
      appBar: AppBar(
        backgroundColor: ds.colors.surface,
        foregroundColor: ds.colors.textPrimary,
        title: Text(
          'SeniorEase — Tarefas',
          style: ds.typography.headingMedium.copyWith(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ColoredBox(
        color: ds.colors.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: isWide ? ds.spacing.xl : 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: ds.spacing.md),
                    LayoutPageContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isWide) _SearchBar(controller: _searchController, onChanged: () => setState(() {})),
                          if (isWide) SizedBox(height: ds.spacing.md),
                          LayoutTasksPageHeader(
                            title: 'Tarefas do dia',
                            subtitle:
                                'Gerencie seu bem-estar com uma lista clara: pendentes e concluídas.',
                            onAddTask: () => _openEditor(context),
                            showWideAddButton: isWide,
                          ),
                          if (!isWide) ...[
                            SizedBox(height: ds.spacing.md),
                            FilledButton.icon(
                              onPressed: () => _openEditor(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: ds.colors.primary,
                                foregroundColor: ds.colors.primaryInverse,
                                minimumSize: Size(double.infinity, ds.spacing.xxl * 1.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: Icon(Icons.add_task, size: ds.icons.md),
                              label: Text(
                                'Nova atividade',
                                style: ds.typography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: ds.spacing.lg),
                          _TabBar(
                            tabIndex: _tabIndex,
                            pendingCount: filtered.length,
                            completedCount: history.length,
                            onChanged: (i) => setState(() => _tabIndex = i),
                          ),
                          SizedBox(height: ds.spacing.lg),
                          if (_tabIndex == 0)
                            _StatsRow(
                              pending: filtered.length,
                              completed: history.length,
                              reminders: tasks.where((t) => t.reminderAt != null).length,
                            ),
                          if (_tabIndex == 0) SizedBox(height: ds.spacing.lg),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: ds.colors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ds.colors.disabled.withValues(alpha: 0.35),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ds.colors.textPrimary.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: _tabIndex == 0
                                  ? (filtered.isEmpty
                                      ? Padding(
                                          padding: EdgeInsets.all(ds.spacing.xxl),
                                          child: Text(
                                            'Nenhuma atividade pendente.\n'
                                            'Use "Nova atividade" para criar.',
                                            textAlign: TextAlign.center,
                                            style: ds.typography.bodyLarge.copyWith(
                                              color: ds.colors.textSecondary,
                                              height: 1.45,
                                            ),
                                          ),
                                        )
                                      : isWide
                                          ? _PendingTable(
                                              tasks: filtered,
                                              onEdit: (t) => _openEditor(context, task: t),
                                              onDelete: (t) => _confirmDelete(context, t),
                                              onWizard: (t) => _confirmOpenWizard(context, t),
                                              onComplete: (t) => _completeQuick(context, t),
                                              formatReminder: _formatReminder,
                                              progressText: _progressText,
                                            )
                                          : _PendingMobileList(
                                              tasks: filtered,
                                              onEdit: (t) => _openEditor(context, task: t),
                                              onDelete: (t) => _confirmDelete(context, t),
                                              onWizard: (t) => _confirmOpenWizard(context, t),
                                              onComplete: (t) => _completeQuick(context, t),
                                              formatReminder: _formatReminder,
                                            ))
                                  : (history.isEmpty
                                      ? Padding(
                                          padding: EdgeInsets.all(ds.spacing.xxl),
                                          child: Text(
                                            'Nenhuma atividade concluída ainda.',
                                            textAlign: TextAlign.center,
                                            style: ds.typography.bodyLarge.copyWith(
                                              color: ds.colors.textSecondary,
                                            ),
                                          ),
                                        )
                                      : _HistoryList(
                                          entries: history,
                                          formatDate: _formatDateTime,
                                        )),
                            ),
                          ),
                          if (_tabIndex == 0 && filtered.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: ds.spacing.md),
                              child: Text(
                                'Mostrando ${filtered.length} pendente(s)',
                                style: ds.typography.bodyMedium.copyWith(
                                  color: ds.colors.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isWide && _tabIndex == 0)
                Positioned(
                  right: ds.spacing.lg,
                  bottom: ds.spacing.xxl + 8,
                  child: FloatingActionButton(
                    onPressed: () => _openEditor(context),
                    backgroundColor: ds.colors.primary,
                    foregroundColor: ds.colors.primaryInverse,
                    child: Icon(Icons.add, size: ds.icons.lg * 1.25),
                  ),
                ),
            ],
          );
          },
        ),
      ),
    );
  }

  String _progressText(Task task) {
    final total = task.steps.length;
    if (total == 0) return 'Sem etapas';
    return 'Etapas: ${task.completedStepsCount}/$total';
  }

  String _formatReminder(DateTime dt) {
    final d =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d · $t';
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        hintText: 'Buscar uma tarefa…',
        prefixIcon: Icon(Icons.search, color: ds.colors.textSecondary),
        filled: true,
        fillColor: ds.colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.35)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.35)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ds.spacing.lg,
          vertical: ds.spacing.md,
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabIndex,
    required this.pendingCount,
    required this.completedCount,
    required this.onChanged,
  });

  final int tabIndex;
  final int pendingCount;
  final int completedCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    Widget tab(int i, String label, int count, IconData icon) {
      final sel = tabIndex == i;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(i),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ds.spacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: sel ? ds.colors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: ds.icons.md, color: sel ? ds.colors.primary : ds.colors.textSecondary),
                SizedBox(width: ds.spacing.sm),
                Flexible(
                  child: Text(
                    '$label${count > 0 ? ' ($count)' : ''}',
                    textAlign: TextAlign.center,
                    style: ds.typography.bodyLarge.copyWith(
                      fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                      color: sel ? ds.colors.primary : ds.colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(0, 'Pendentes', pendingCount, Icons.event_note_outlined),
        tab(1, 'Concluídas', completedCount, Icons.check_circle_outline),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.pending,
    required this.completed,
    required this.reminders,
  });

  final int pending;
  final int completed;
  final int reminders;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final children = [
      _StatCard(
        label: 'PENDENTE',
        value: '$pending',
        color: ds.colors.primary,
        icon: Icons.pending_actions_outlined,
      ),
      _StatCard(
        label: 'CONCLUÍDO',
        value: '$completed',
        color: ds.colors.feedbackSuccess,
        icon: Icons.task_alt,
      ),
      _StatCard(
        label: 'LEMBRETE',
        value: '$reminders',
        color: ds.colors.feedbackWarning,
        icon: Icons.notifications_active_outlined,
      ),
    ];
    if (narrow) {
      return Column(
        children: children
            .map((w) => Padding(
                  padding: EdgeInsets.only(bottom: ds.spacing.sm),
                  child: w,
                ))
            .toList(),
      );
    }
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) SizedBox(width: ds.spacing.md),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Container(
      padding: EdgeInsets.all(ds.spacing.lg),
      decoration: BoxDecoration(
        color: ds.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ds.colors.disabled.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: ds.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ds.typography.caption.copyWith(
                    color: ds.colors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  value,
                  style: ds.typography.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
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

class _PendingTable extends StatelessWidget {
  const _PendingTable({
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
        final w = constraints.maxWidth;
        if (!w.isFinite || w <= 0) {
          return const SizedBox.shrink();
        }
        const minTable = 720.0;
        final tableWidth = w < minTable ? minTable : w;
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
            horizontalInside: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.2)),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: ds.colors.background),
              children: [
                _th(context, 'TAREFA'),
                _th(context, 'HORÁRIO'),
                _th(context, 'AÇÕES', align: TextAlign.end),
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
                              padding: EdgeInsets.only(top: ds.spacing.xs / 2),
                              child: Icon(taskCategoryIcon(task.category), size: ds.icons.sm, color: ds.colors.primary),
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
                        if (task.description != null && task.description!.isNotEmpty) ...[
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
                        ? LayoutTimePill(label: formatReminder(task.reminderAt!))
                        : Text('—', style: ds.typography.bodyMedium.copyWith(color: ds.colors.textSecondary)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ds.spacing.md),
                    child: _TableActions(
                      task: task,
                      onEdit: onEdit,
                      onDelete: onDelete,
                      onWizard: onWizard,
                      onComplete: onComplete,
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

  Widget _th(BuildContext context, String t, {TextAlign align = TextAlign.start}) {
    final ds = context.ds;
    return Padding(
      padding: EdgeInsets.all(ds.spacing.lg),
      child: Text(
        t,
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

class _TableActions extends StatelessWidget {
  const _TableActions({
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
  });

  final Task task;
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
        if (task.steps.isNotEmpty)
          IconButton(
            onPressed: () => onWizard(task),
            icon: const Icon(Icons.route),
            tooltip: 'Guia',
          ),
        if (task.steps.isEmpty || task.steps.every((s) => s.completed))
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
          icon: Icon(Icons.delete_outline, color: context.ds.colors.feedbackDanger),
          tooltip: 'Excluir',
        ),
      ],
    );
  }
}

class _PendingMobileList extends StatelessWidget {
  const _PendingMobileList({
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onWizard,
    required this.onComplete,
    required this.formatReminder,
  });

  final List<Task> tasks;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;
  final String Function(DateTime) formatReminder;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(ds.spacing.md),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => SizedBox(height: ds.spacing.md),
      itemBuilder: (context, i) {
        final task = tasks[i];
        final time = task.reminderAt != null ? formatReminder(task.reminderAt!) : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutTaskCardRow(
              title: task.title,
              subtitle: task.description,
              timeLabel: time,
              categoryIcon: taskCategoryIcon(task.category),
              onEdit: () => onEdit(task),
              onDelete: () => onDelete(task),
              onOpenGuide: task.steps.isNotEmpty ? () => onWizard(task) : null,
            ),
            SizedBox(height: ds.spacing.sm),
            _MobileActions(
              task: task,
              onWizard: onWizard,
              onComplete: onComplete,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        );
      },
    );
  }
}

class _MobileActions extends StatelessWidget {
  const _MobileActions({
    required this.task,
    required this.onWizard,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final void Function(Task) onWizard;
  final void Function(Task) onComplete;
  final void Function(Task) onEdit;
  final void Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    final gap = context.ds.spacing.sm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (task.steps.isNotEmpty) ...[
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
        if (task.steps.isEmpty)
          DSButton(
            label: 'Concluir atividade',
            icon: Icons.celebration,
            fullWidth: true,
            onPressed: () => onComplete(task),
          ),
        if (task.steps.isNotEmpty && task.steps.every((s) => s.completed)) ...[
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

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.entries,
    required this.formatDate,
  });

  final List<ActivityHistoryEntry> entries;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(ds.spacing.md),
      itemCount: entries.length,
      separatorBuilder: (_, _) => SizedBox(height: ds.spacing.md),
      itemBuilder: (context, i) {
        final e = entries[i];
        return LayoutTaskCardRow(
          title: e.taskTitle,
          subtitle: e.positiveMessage,
          timeLabel: formatDate(e.completedAt),
          showCheckbox: true,
          completedLook: true,
          showActions: false,
          onEdit: () {},
          onDelete: () {},
          onOpenGuide: null,
        );
      },
    );
  }
}
