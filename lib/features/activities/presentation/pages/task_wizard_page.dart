import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_card/ds_card.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_switch_tile/ds_switch_tile.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
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

  Task? _taskFrom(TasksController c) {
    try {
      return c.tasks.firstWhere((t) => t.id == widget.taskId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _toggleStep(Task task, int stepIndex, bool value) async {
    final steps = List<TaskStep>.from(task.steps);
    steps[stepIndex] = steps[stepIndex].copyWith(completed: value);
    final updated = task.copyWith(steps: steps);
    await context.read<TasksController>().saveProgress(updated);
  }

  Future<void> _finish() async {
    final task = _taskFrom(context.read<TasksController>());
    if (task == null || !mounted) return;
    if (!task.steps.every((s) => s.completed)) {
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
          'O histórico guardará uma mensagem informativa de conclusão.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Confirmar', style: ds.typography.label),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final entry =
        await context.read<TasksController>().completeTask(task.id);
    if (!mounted) return;
    await context.read<TasksController>().loadHistory();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          entry.positiveMessage,
          style: ds.typography.bodyLarge,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
    Navigator.of(context).pop();
  }

  void _next(int totalPages) {
    if (_pageIndex >= totalPages - 1) return;
    setState(() => _pageIndex++);
    _pageController.animateToPage(
      _pageIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _prev() {
    if (_pageIndex <= 0) return;
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
      return Scaffold(
        appBar: AppBar(title: const Text('Guia')),
        body: Center(
          child: Text(
            'Tarefa não encontrada.',
            style: ds.typography.bodyLarge,
          ),
        ),
      );
    }

    if (task.steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Guia')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(ds.spacing.lg),
            child: Text(
              'Esta atividade não tem etapas. Use "Concluir" na lista.',
              textAlign: TextAlign.center,
              style: ds.typography.bodyLarge,
            ),
          ),
        ),
      );
    }

    final total = task.steps.length;

    return Scaffold(
      backgroundColor: ds.colors.background,
      appBar: AppBar(
        backgroundColor: ds.colors.surface,
        iconTheme: IconThemeData(color: ds.colors.textPrimary),
        title: Text(
          'Etapa ${_pageIndex + 1} de $total',
          style: ds.typography.headingMedium.copyWith(color: ds.colors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_pageIndex + 1) / total,
            backgroundColor: ds.colors.disabled.withValues(alpha: 0.25),
            color: ds.colors.primary,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              itemBuilder: (context, i) {
                final s = task.steps[i];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(ds.spacing.lg),
                  child: DsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s.label,
                          style: ds.typography.headingLarge.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: ds.spacing.lg),
                        DsSwitchTile(
                          title: s.completed ? 'Etapa feita' : 'Marcar como feita',
                          value: s.completed,
                          onChanged: (v) => _toggleStep(task, i, v),
                          icon: Icons.check_circle_outline,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ds.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (_pageIndex > 0)
                      Expanded(
                        child: DSButton(
                          label: 'Anterior',
                          variant: DSButtonVariant.secondary,
                          onPressed: _prev,
                        ),
                      ),
                    if (_pageIndex > 0) SizedBox(width: ds.spacing.md),
                    Expanded(
                      child: DSButton(
                        label: _pageIndex >= total - 1 ? 'Concluir atividade' : 'Próxima etapa',
                        icon: _pageIndex >= total - 1 ? Icons.celebration : Icons.arrow_forward,
                        onPressed: () {
                          if (_pageIndex >= total - 1) {
                            _finish();
                          } else {
                            _next(total);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
