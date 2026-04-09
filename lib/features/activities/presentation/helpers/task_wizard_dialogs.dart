import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';

Future<bool> showTaskWizardCompleteDialog(BuildContext context) async {
  final ds = context.ds;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: ds.colors.surface,
      title: Text('Concluir atividade?', style: ds.typography.headingMedium),
      content: Text(
        'O histórico guardará uma mensagem informativa de conclusão.',
        style: ds.typography.bodyMedium,
      ),
      actions: [
        DSButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          label: "Cancelar",
          variant: DSButtonVariant.danger,
        ),
        DSButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          label: "Confirmar",
        ),
      ],
    ),
  );
  return result == true;
}
