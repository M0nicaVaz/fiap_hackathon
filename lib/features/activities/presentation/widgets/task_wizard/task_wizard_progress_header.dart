import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class TaskWizardProgressHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const TaskWizardProgressHeader({
    super.key,
    required this.pageIndex,
    required this.totalSteps,
  });

  final int pageIndex;
  final int totalSteps;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return AppBar(
      backgroundColor: ds.colors.surface,
      iconTheme: IconThemeData(color: ds.colors.textPrimary),
      title: Text(
        'Etapa ${pageIndex + 1} de $totalSteps',
        style: ds.typography.headingMedium.copyWith(
          color: ds.colors.textPrimary,
        ),
      ),
    );
  }
}

class TaskWizardProgressBar extends StatelessWidget {
  const TaskWizardProgressBar({
    super.key,
    required this.pageIndex,
    required this.totalSteps,
  });

  final int pageIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return LinearProgressIndicator(
      value: (pageIndex + 1) / totalSteps,
      backgroundColor: ds.colors.disabled.withValues(alpha: 0.25),
      color: ds.colors.primary,
    );
  }
}
