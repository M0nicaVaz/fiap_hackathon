import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:flutter/material.dart';

const double kTaskCategoryCardMinWidth = 104;

class TaskCategorySection extends StatelessWidget {
  const TaskCategorySection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskCategory value;
  final ValueChanged<TaskCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Categoria',
          style: ds.typography.bodyLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: ds.spacing.md),
        TaskCategorySelector(value: value, onChanged: onChanged),
      ],
    );
  }
}

class TaskCategorySelector extends StatelessWidget {
  const TaskCategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskCategory value;
  final ValueChanged<TaskCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final categories = TaskCategory.values;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;
        if (isWide) {
          final spacing = ds.spacing.sm;
          final maxWidth = constraints.maxWidth;
          final fontScale = ds.scale.fontScale;
          final minCard = (kTaskCategoryCardMinWidth * fontScale).clamp(
            72.0,
            640.0,
          );
          final rawColumns = ((maxWidth + spacing) / (minCard + spacing))
              .floor();
          final columns = rawColumns.clamp(1, categories.length);
          final cardWidth = (maxWidth - (columns - 1) * spacing) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: categories
                .map(
                  (category) => SizedBox(
                    width: cardWidth,
                    child: TaskCategoryTile(
                      category: category,
                      selected: value == category,
                      onTap: () => onChanged(category),
                    ),
                  ),
                )
                .toList(),
          );
        }
        return Column(
          children: categories
              .map(
                (category) => Padding(
                  padding: EdgeInsets.only(bottom: ds.spacing.sm),
                  child: TaskCategoryTile(
                    category: category,
                    selected: value == category,
                    onTap: () => onChanged(category),
                    stadium: true,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class TaskCategoryTile extends StatelessWidget {
  const TaskCategoryTile({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
    this.stadium = false,
  });

  final TaskCategory category;
  final bool selected;
  final VoidCallback onTap;
  final bool stadium;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final borderColor = selected
        ? ds.colors.primary
        : ds.colors.disabled.withValues(alpha: 0.4);
    final foregroundColor = selected
        ? ds.colors.primary
        : ds.colors.textPrimary;
    final iconColor = selected
        ? ds.colors.primary
        : ds.colors.textSecondary;

    return Material(
      color: ds.colors.surface,
      borderRadius: BorderRadius.circular(stadium ? 999 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(stadium ? 999 : 16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ds.spacing.md,
            vertical: stadium ? ds.spacing.md : ds.spacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(stadium ? 999 : 16),
            border: Border.all(
              color: borderColor,
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: stadium
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      taskCategoryIcon(category),
                      color: iconColor,
                      size: ds.icons.lg,
                    ),
                    SizedBox(width: ds.spacing.md),
                    Text(
                      category.labelPt,
                      style: ds.typography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: foregroundColor,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      taskCategoryIcon(category),
                      color: iconColor,
                      size: ds.icons.lg * 1.1,
                    ),
                    SizedBox(height: ds.spacing.sm),
                    Text(
                      category.labelPt,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      textWidthBasis: TextWidthBasis.parent,
                      style: ds.typography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: foregroundColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
