import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/activity_history_entry.dart';
import 'package:flutter/material.dart';

class CompletedTasksSection extends StatelessWidget {
  const CompletedTasksSection({
    super.key,
    required this.entries,
    required this.formatDate,
  });

  final List<ActivityHistoryEntry> entries;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    if (entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(ds.spacing.xxl),
        child: Text(
          'Nenhuma atividade concluída ainda.',
          textAlign: TextAlign.center,
          style: ds.typography.bodyLarge.copyWith(
            color: ds.colors.textSecondary,
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(ds.spacing.md),
      itemCount: entries.length,
      separatorBuilder: (_, _) => SizedBox(height: ds.spacing.md),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return LayoutTaskCardRow(
          title: entry.taskTitle,
          subtitle: entry.positiveMessage,
          timeLabel: formatDate(entry.completedAt),
          showCheckbox: true,
          completedLook: true,
          onEdit: () {},
          onDelete: () {},
          onOpenGuide: null,
        );
      },
    );
  }
}
