import 'dart:async';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:fiap_hackathon/features/accessibility_preferences/presentation/providers/accessibility_preferences_controller.dart';
import 'package:fiap_hackathon/features/activities/presentation/pages/task_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../navigation/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = time.minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }

  String _formatDate(DateTime date) {
    const days = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} de $monthName';
  }

  TextStyle _sectionTitleStyle(BuildContext context, bool reinforced) {
    final ds = context.ds;
    var baseStyle = ds.typography.headingMedium;
    if (reinforced) {
      return baseStyle.copyWith(
        fontWeight: FontWeight.w900,
        decoration: TextDecoration.underline,
        decorationColor: ds.colors.primary,
        decorationThickness: 2,
      );
    }
    return baseStyle.copyWith(fontWeight: FontWeight.w800);
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final accessCtrl = context.watch<AccessibilityPreferencesController>();
    final taskCtrl = context.watch<TasksController>();

    final pendingTasks = taskCtrl.tasks;
    final reminders = taskCtrl.dueReminders.isNotEmpty
        ? taskCtrl.dueReminders
        : taskCtrl.tasks.where((t) => t.reminderAt != null).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(ds.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGreetingSection(context),
          SizedBox(height: ds.spacing.lg),
          _buildWeatherTimeCard(context, taskCtrl.tasks),
          if (accessCtrl.isBasicMode) ...[
            SizedBox(height: ds.spacing.lg),
            _buildSimplifiedNavigation(context),
          ],
          SizedBox(height: ds.spacing.xxl),
          _buildSectionTitle(
            context,
            'Atividades de Hoje',
            accessCtrl.reinforcedFeedback,
            trailing: '${pendingTasks.length} restantes',
          ),
          SizedBox(height: ds.spacing.md),
          _buildTasksList(context, pendingTasks),
          SizedBox(height: ds.spacing.xxl),
          _buildSectionTitle(
            context,
            'Próximos Lembretes',
            accessCtrl.reinforcedFeedback,
          ),
          SizedBox(height: ds.spacing.md),
          _buildRemindersList(context, reminders),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    final ds = context.ds;
    final hour = _now.hour;
    final greeting = hour < 12
        ? 'Bom dia'
        : (hour < 18 ? 'Boa tarde' : 'Boa noite');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,\nArthur!',
          style: ds.typography.headingLarge.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 32 * ds.scale.fontScale,
            height: 1.2,
          ),
        ),
        SizedBox(height: ds.spacing.sm),
        Text(
          'É um ótimo dia para manter a organização.',
          style: ds.typography.bodyLarge.copyWith(
            color: ds.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherTimeCard(BuildContext context, List<Task> tasks) {
    final ds = context.ds;

    String timeUntilNextEvent() {
      DateTime now = DateTime.now();
      var upcoming = tasks
          .where((t) => t.reminderAt != null && t.reminderAt!.isAfter(now))
          .toList();
      if (upcoming.isEmpty) {
        return 'Agenda livre no momento';
      }
      upcoming.sort((a, b) => a.reminderAt!.compareTo(b.reminderAt!));
      final next = upcoming.first.reminderAt!;
      final diff = next.difference(now);

      if (diff.inDays > 0) {
        return 'Próximo agendamento em ${diff.inDays} d';
      } else if (diff.inHours > 0) {
        return 'Próximo agendamento em ${diff.inHours} h';
      } else if (diff.inMinutes > 0) {
        return 'Próximo agendamento em ${diff.inMinutes} min';
      } else {
        return 'Atividade agora!';
      }
    }

    return Container(
      padding: EdgeInsets.all(ds.spacing.xl),
      decoration: BoxDecoration(
        color: ds.colors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ds.colors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ds.spacing.sm),
            decoration: BoxDecoration(
              color: ds.colors.primaryInverse,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_filled,
              color: ds.colors.primary,
              size: 32,
            ),
          ),
          SizedBox(width: ds.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatTime(_now),
                  style: ds.typography.headingLarge.copyWith(
                    color: ds.colors.primaryInverse,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _formatDate(_now),
                  style: ds.typography.bodyMedium.copyWith(
                    color: ds.colors.primaryInverse.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: ds.spacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ds.spacing.md,
                    vertical: ds.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: ds.colors.primaryInverse.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    timeUntilNextEvent(),
                    style: ds.typography.bodyMedium.copyWith(
                      color: ds.colors.primaryInverse,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimplifiedNavigation(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BigNavButton(
          title: 'Ver Todas as Tarefas',
          icon: Icons.check_circle_outline,
          color: ds.colors.surface,
          textColor: ds.colors.textPrimary,
          iconColor: ds.colors.primary,
          onTap: () {
            context.go(AppRoutes.activities);
          },
        ),
        SizedBox(height: ds.spacing.md),
        _BigNavButton(
          title: 'Adicionar Nova Tarefa',
          icon: Icons.add_circle,
          color: ds.colors.primary,
          textColor: ds.colors.primaryInverse,
          iconColor: ds.colors.primaryInverse,
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TaskEditorPage()));
          },
        ),
        SizedBox(height: ds.spacing.md),
        _BigNavButton(
          title: 'Acessibilidade',
          icon: Icons.accessibility_new,
          color: ds.colors.surface,
          textColor: ds.colors.textPrimary,
          iconColor: ds.colors.primary,
          onTap: () {
            context.go(AppRoutes.customization);
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    bool reinforced, {
    String? trailing,
  }) {
    final ds = context.ds;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: _sectionTitleStyle(context, reinforced)),
        if (trailing != null)
          Text(
            trailing,
            style: ds.typography.bodyMedium.copyWith(
              color: ds.colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }

  Widget _buildTasksList(BuildContext context, List<Task> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState(context, 'Tudo concluído por hoje!');
    }
    return Column(
      children: tasks.take(3).map((task) => _TaskCard(task: task)).toList(),
    );
  }

  Widget _buildRemindersList(BuildContext context, List<Task> reminders) {
    if (reminders.isEmpty) {
      return _buildEmptyState(context, 'Nenhum lembrete para hoje.');
    }
    return Column(
      children: reminders
          .take(3)
          .map((task) => _TaskCard(task: task, isReminder: true))
          .toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final ds = context.ds;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ds.spacing.xl),
      child: Center(
        child: Text(
          message,
          style: ds.typography.bodyLarge.copyWith(
            color: ds.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _BigNavButton extends StatelessWidget {
  const _BigNavButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ds.spacing.lg),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: ds.colors.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: ds.colors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 36 * ds.scale.fontScale, color: iconColor),
            SizedBox(height: ds.spacing.sm),
            Text(
              title,
              style: ds.typography.headingMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, this.isReminder = false});

  final Task task;
  final bool isReminder;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    final iconColor = isReminder
        ? ds.colors.feedbackWarning
        : ds.colors.primary;
    final iconData = isReminder
        ? Icons.notifications_active
        : Icons.radio_button_unchecked;

    String formatDue() {
      if (task.reminderAt == null) return 'Sem horário definido';
      final r = task.reminderAt!;
      final h = r.hour.toString().padLeft(2, '0');
      final m = r.minute.toString().padLeft(2, '0');
      return 'Às $h:$m';
    }

    return Container(
      margin: EdgeInsets.only(bottom: ds.spacing.md),
      decoration: BoxDecoration(
        color: ds.colors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: ds.colors.disabled.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: ds.colors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TaskEditorPage(initialTask: task),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ds.spacing.lg,
              vertical: ds.spacing.lg,
            ),
            child: Row(
              children: [
                Icon(iconData, color: iconColor, size: ds.icons.lg),
                SizedBox(width: ds.spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: ds.typography.headingMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        formatDue(),
                        style: ds.typography.bodyMedium.copyWith(
                          color: ds.colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
