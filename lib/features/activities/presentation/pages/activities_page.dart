import 'dart:async';

import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/activity_history_entry.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/activities_dialogs.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/activities_formatters.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/activities_navigation.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/activities_page_shell.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/activities_summary_section.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/activities_toolbar.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/completed_tasks_section.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/activities/pending_tasks_section.dart';
import 'package:flutter/material.dart';
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
    if (!mounted) {
      return;
    }
    final controller = context.read<TasksController>();
    final dueTasks = controller.dueReminders;
    if (dueTasks.isEmpty) {
      return;
    }

    final ds = context.ds;
    final task = dueTasks.first;
    controller.dismissReminder(task.id);

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: ds.colors.surface,
        content: Text(
          'Lembrete: "${task.title}". Toque em "Abrir" para ver a atividade.',
          style: ds.typography.bodyMedium.copyWith(
            color: ds.colors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              openTaskWizard(context, task);
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

  Future<void> _confirmDelete(Task task) async {
    final confirmed = await showDeleteActivityDialog(context);
    if (!confirmed || !mounted) {
      return;
    }
    await context.read<TasksController>().deleteTask(task.id);
    if (!mounted) {
      return;
    }
    _snack('Atividade removida.');
  }

  Future<void> _confirmOpenWizard(Task task) async {
    final confirmed = await showOpenWizardDialog(context);
    if (!confirmed || !mounted) {
      return;
    }
    await openTaskWizard(context, task);
  }

  Future<void> _completeQuick(Task task) async {
    final confirmed = await showCompleteActivityDialog(context);
    if (!confirmed || !mounted) {
      return;
    }

    final tasksController = context.read<TasksController>();
    final entry = await tasksController.completeTask(task.id);
    if (!mounted) {
      return;
    }
    await tasksController.loadHistory();
    if (!mounted) {
      return;
    }
    _snack(entry.positiveMessage);
  }

  void _snack(String message) {
    final ds = context.ds;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: ds.typography.bodyMedium),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.select<TasksController, List<Task>>(
      (controller) => controller.tasks,
    );
    final history = context.select<TasksController, List<ActivityHistoryEntry>>(
      (controller) => controller.history,
    );
    final filteredTasks = filterTasksByQuery(tasks, _searchController.text);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final tabContent = DecoratedBox(
          decoration: BoxDecoration(
            color: context.ds.colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.ds.colors.disabled.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: context.ds.colors.textPrimary.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _tabIndex == 0
                ? PendingTasksSection(
                    tasks: filteredTasks,
                    isWide: isWide,
                    onEdit: (task) => openTaskEditor(context, task: task),
                    onDelete: _confirmDelete,
                    onWizard: _confirmOpenWizard,
                    onComplete: _completeQuick,
                    formatReminder: formatTaskReminder,
                    progressText: formatTaskProgress,
                  )
                : CompletedTasksSection(
                    entries: history,
                    formatDate: formatActivityHistoryDateTime,
                  ),
          ),
        );

        return ActivitiesPageShell(
          toolbar: ActivitiesToolbar(
            isWide: isWide,
            searchController: _searchController,
            onSearchChanged: () => setState(() {}),
            onAddTask: () => openTaskEditor(context),
          ),
          summary: ActivitiesSummarySection(
            pendingCount: filteredTasks.length,
            completedCount: history.length,
            remindersCount:
                tasks.where((task) => task.reminderAt != null).length,
            tabIndex: _tabIndex,
            onTabChanged: (index) => setState(() => _tabIndex = index),
          ),
          content: tabContent,
          footer: _tabIndex == 0 && filteredTasks.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: context.ds.spacing.md),
                  child: Text(
                    'Mostrando ${filteredTasks.length} pendente(s)',
                    style: context.ds.typography.bodyMedium.copyWith(
                      color: context.ds.colors.textSecondary,
                    ),
                  ),
                )
              : null,
          showFab: !isWide && _tabIndex == 0,
          onAddTask: () => openTaskEditor(context),
        );
      },
    );
  }
}
