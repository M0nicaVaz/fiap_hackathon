import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class LayoutConstants {
  LayoutConstants._();

  static const double maxContentWidth = 1200;
  static const double widePaddingH = 40;
  static const double narrowPaddingH = 24;
}

class LayoutPageContainer extends StatelessWidget {
  const LayoutPageContainer({
    super.key,
    required this.child,
    this.maxWidth = LayoutConstants.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final h = wide
            ? LayoutConstants.widePaddingH
            : LayoutConstants.narrowPaddingH;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: h),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class LayoutTasksPageHeader extends StatelessWidget {
  const LayoutTasksPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onAddTask,
    this.showWideAddButton = true,
  });

  final String title;
  final String subtitle;
  final VoidCallback onAddTask;
  final bool showWideAddButton;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Padding(
      padding: EdgeInsets.only(bottom: ds.spacing.lg),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        softWrap: true,
                        textWidthBasis: TextWidthBasis.parent,
                        style: ds.typography.headingLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: ds.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: ds.spacing.sm),
                      Text(
                        subtitle,
                        softWrap: true,
                        textWidthBasis: TextWidthBasis.parent,
                        style: ds.typography.bodyLarge.copyWith(
                          color: ds.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showWideAddButton) ...[
                  SizedBox(width: ds.spacing.lg),
                  FilledButton.icon(
                    onPressed: onAddTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: ds.colors.primary,
                      foregroundColor: ds.colors.primaryInverse,
                      padding: EdgeInsets.symmetric(
                        horizontal: ds.spacing.lg,
                        vertical: ds.spacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.add_task, size: ds.icons.md),
                    label: Text(
                      'Nova atividade',
                      style: ds.typography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ds.colors.primaryInverse,
                      ),
                    ),
                  ),
                ],
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.parent,
                  style: ds.typography.headingLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: ds.spacing.sm),
                Text(
                  subtitle,
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.parent,
                  style: ds.typography.bodyLarge.copyWith(
                    color: ds.colors.textSecondary,
                  ),
                ),
              ],
            ),
    );
  }
}

class LayoutTimePill extends StatelessWidget {
  const LayoutTimePill({super.key, required this.label, this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ds.spacing.md,
        vertical: compact ? ds.spacing.xs : ds.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: ds.colors.feedbackWarningLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: ds.colors.feedbackWarning.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: ds.icons.sm,
            color: ds.colors.feedbackWarning,
          ),
          SizedBox(width: ds.spacing.sm),
          Flexible(
            child: Text(
              label,
              softWrap: true,
              textWidthBasis: TextWidthBasis.parent,
              style: ds.typography.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: ds.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LayoutTaskCardRow extends StatelessWidget {
  const LayoutTaskCardRow({
    super.key,
    required this.title,
    this.subtitle,
    this.timeLabel,
    this.categoryIcon,
    required this.onEdit,
    required this.onDelete,
    this.onOpenGuide,
    this.showCheckbox = true,
    this.completedLook = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? timeLabel;
  final IconData? categoryIcon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onOpenGuide;
  final bool showCheckbox;
  final bool completedLook;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final fg = completedLook ? ds.colors.textSecondary : ds.colors.textPrimary;
    return Material(
      color: ds.colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(ds.spacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: completedLook
                ? ds.colors.disabled.withValues(alpha: 0.5)
                : ds.colors.disabled.withValues(alpha: 0.25),
            style: completedLook ? BorderStyle.solid : BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: ds.colors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (categoryIcon != null) ...[
                        Icon(
                          categoryIcon,
                          size: ds.icons.sm,
                          color: ds.colors.primary,
                        ),
                        SizedBox(width: ds.spacing.xs),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          softWrap: true,
                          textWidthBasis: TextWidthBasis.parent,
                          style: ds.typography.headingMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    SizedBox(height: ds.spacing.xs),
                    Text(
                      subtitle!,
                      softWrap: true,
                      textWidthBasis: TextWidthBasis.parent,
                      style: ds.typography.bodyMedium.copyWith(
                        color: ds.colors.textSecondary,
                      ),
                    ),
                  ],
                  if (timeLabel != null) ...[
                    SizedBox(height: ds.spacing.sm),
                    LayoutTimePill(label: timeLabel!, compact: true),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: ds.spacing.md),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
