import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class ActivitiesSummarySection extends StatelessWidget {
  const ActivitiesSummarySection({
    super.key,
    required this.pendingCount,
    required this.completedCount,
    required this.remindersCount,
    required this.tabIndex,
    required this.onTabChanged,
  });

  final int pendingCount;
  final int completedCount;
  final int remindersCount;
  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActivitiesStatsRow(
          pending: pendingCount,
          completed: completedCount,
          reminders: remindersCount,
        ),
        SizedBox(height: ds.spacing.lg),
        ActivitiesTabBar(
          tabIndex: tabIndex,
          pendingCount: pendingCount,
          completedCount: completedCount,
          onChanged: onTabChanged,
        ),
      ],
    );
  }
}

class ActivitiesTabBar extends StatelessWidget {
  const ActivitiesTabBar({
    super.key,
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
    return Row(
      children: [
        _ActivitiesTab(
          label: 'Pendentes',
          count: pendingCount,
          icon: Icons.event_note_outlined,
          selected: tabIndex == 0,
          onTap: () => onChanged(0),
        ),
        _ActivitiesTab(
          label: 'Concluídas',
          count: completedCount,
          icon: Icons.check_circle_outline,
          selected: tabIndex == 1,
          onTap: () => onChanged(1),
        ),
      ],
    );
  }
}

class _ActivitiesTab extends StatelessWidget {
  const _ActivitiesTab({
    required this.label,
    required this.count,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ds.spacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? ds.colors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ds.icons.md,
                color: selected ? ds.colors.primary : ds.colors.textSecondary,
              ),
              SizedBox(width: ds.spacing.sm),
              Flexible(
                child: Text(
                  '$label${count > 0 ? ' ($count)' : ''}',
                  textAlign: TextAlign.center,
                  style: ds.typography.bodyLarge.copyWith(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    color: selected
                        ? ds.colors.primary
                        : ds.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivitiesStatsRow extends StatelessWidget {
  const ActivitiesStatsRow({
    super.key,
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
      _ActivitiesStatCard(
        label: 'PENDENTE',
        value: '$pending',
        color: ds.colors.primary,
        icon: Icons.pending_actions_outlined,
      ),
      _ActivitiesStatCard(
        label: 'CONCLUÍDO',
        value: '$completed',
        color: ds.colors.feedbackSuccess,
        icon: Icons.task_alt,
      ),
      _ActivitiesStatCard(
        label: 'LEMBRETE',
        value: '$reminders',
        color: ds.colors.feedbackWarning,
        icon: Icons.notifications_active_outlined,
      ),
    ];
    if (narrow) {
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: EdgeInsets.only(bottom: ds.spacing.sm),
                child: child,
              ),
            )
            .toList(),
      );
    }
    return Row(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          Expanded(child: children[index]),
          if (index < children.length - 1) SizedBox(width: ds.spacing.md),
        ],
      ],
    );
  }
}

class _ActivitiesStatCard extends StatelessWidget {
  const _ActivitiesStatCard({
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
        border: Border.all(
          color: ds.colors.disabled.withValues(alpha: 0.25),
        ),
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
