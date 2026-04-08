import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';

class TaskWizardBottomActions extends StatelessWidget {
  const TaskWizardBottomActions({
    super.key,
    required this.pageIndex,
    required this.totalSteps,
    required this.onPrevious,
    required this.onNextOrFinish,
  });

  final int pageIndex;
  final int totalSteps;
  final VoidCallback onPrevious;
  final VoidCallback onNextOrFinish;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final isLastPage = pageIndex >= totalSteps - 1;
    return Padding(
      padding: EdgeInsets.all(ds.spacing.lg),
      child: Row(
        children: [
          if (pageIndex > 0)
            Expanded(
              child: DSButton(
                label: 'Anterior',
                variant: DSButtonVariant.secondary,
                onPressed: onPrevious,
              ),
            ),
          if (pageIndex > 0) SizedBox(width: ds.spacing.md),
          Expanded(
            child: DSButton(
              label: isLastPage ? 'Concluir atividade' : 'Próxima etapa',
              icon: isLastPage ? Icons.celebration : Icons.arrow_forward,
              onPressed: onNextOrFinish,
            ),
          ),
        ],
      ),
    );
  }
}
