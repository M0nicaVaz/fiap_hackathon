import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

Future<bool> showTaskWizardCompleteDialog(BuildContext context) async {
  final ds = context.ds;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
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
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text('Cancelar', style: ds.typography.label),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text('Confirmar', style: ds.typography.label),
        ),
      ],
    ),
  );
  return result == true;
}
