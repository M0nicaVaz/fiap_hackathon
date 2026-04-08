import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_card/ds_card.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_switch_tile/ds_switch_tile.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:flutter/material.dart';

class TaskWizardStepPage extends StatelessWidget {
  const TaskWizardStepPage({
    super.key,
    required this.step,
    required this.onChanged,
  });

  final TaskStep step;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return SingleChildScrollView(
      padding: EdgeInsets.all(ds.spacing.lg),
      child: DsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              step.label,
              style: ds.typography.headingLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: ds.spacing.lg),
            DsSwitchTile(
              title: step.completed ? 'Etapa feita' : 'Marcar como feita',
              value: step.completed,
              onChanged: onChanged,
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }
}
