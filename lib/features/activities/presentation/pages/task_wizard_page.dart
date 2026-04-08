import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/task_wizard_dialogs.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_wizard/task_wizard_bottom_actions.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_wizard/task_wizard_empty_state.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_wizard/task_wizard_progress_header.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_wizard/task_wizard_step_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskWizardPage extends StatefulWidget {
  const TaskWizardPage({super.key, required this.taskId});
  final String taskId;

  @override
  State<TaskWizardPage> createState() => _TaskWizardPageState();
}

class _TaskWizardPageState extends State<TaskWizardPage> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Task? _taskFrom(TasksController controller) {
    try {
      return controller.tasks.firstWhere((task) => task.id == widget.taskId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _toggleStep(Task task, int stepIndex, bool value) async {
    final steps = List<TaskStep>.from(task.steps);
    steps[stepIndex] = steps[stepIndex].copyWith(completed: value);
    final updatedTask = task.copyWith(steps: steps);
    await context.read<TasksController>().saveProgress(updatedTask);
  }

  Future<void> _finish() async {
    final task = _taskFrom(context.read<TasksController>());
    if (task == null || !mounted) {
      return;
    }
    if (!task.steps.every((step) => step.completed)) {
      final ds = context.ds;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Marque todas as etapas como feitas antes de concluir.',
            style: ds.typography.bodyMedium,
          ),
        ),
      );
      return;
    }

    final confirmed = await showTaskWizardCompleteDialog(context);
    if (!confirmed || !mounted) {
      return;
    }

    final entry = await context.read<TasksController>().completeTask(task.id);
    if (!mounted) {
      return;
    }
    await context.read<TasksController>().loadHistory();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          entry.positiveMessage,
          style: context.ds.typography.bodyLarge,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
    Navigator.of(context).pop();
  }

  void _next(int totalPages) {
    if (_pageIndex >= totalPages - 1) {
      return;
    }
    setState(() => _pageIndex++);
    _pageController.animateToPage(
      _pageIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _previous() {
    if (_pageIndex <= 0) {
      return;
    }
    setState(() => _pageIndex--);
    _pageController.animateToPage(
      _pageIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final task = _taskFrom(context.watch<TasksController>());
    if (task == null) {
      return const TaskWizardEmptyState(
        message: 'Tarefa não encontrada.',
      );
    }
    if (task.steps.isEmpty) {
      return const TaskWizardEmptyState(
        message: 'Esta atividade não tem etapas. Use "Concluir" na lista.',
      );
    }

    final totalSteps = task.steps.length;
    return Scaffold(
      backgroundColor: ds.colors.background,
      appBar: TaskWizardProgressHeader(
        pageIndex: _pageIndex,
        totalSteps: totalSteps,
      ),
      body: Column(
        children: [
          TaskWizardProgressBar(
            pageIndex: _pageIndex,
            totalSteps: totalSteps,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalSteps,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              itemBuilder: (context, index) {
                return TaskWizardStepPage(
                  step: task.steps[index],
                  onChanged: (value) => _toggleStep(task, index, value),
                );
              },
            ),
          ),
          TaskWizardBottomActions(
            pageIndex: _pageIndex,
            totalSteps: totalSteps,
            onPrevious: _previous,
            onNextOrFinish: () {
              if (_pageIndex >= totalSteps - 1) {
                _finish();
              } else {
                _next(totalSteps);
              }
            },
          ),
        ],
      ),
    );
  }
}
