import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteActivityDialog(BuildContext context) async {
  final ds = context.ds;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text(
          'Excluir atividade?',
          style: ds.typography.headingMedium,
        ),
        content: Text(
          'Esta ação não pode ser desfeita.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancelar', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Excluir',
              style: ds.typography.label.copyWith(
                color: ds.colors.feedbackDanger,
              ),
            ),
          ),
        ],
      );
    },
  );
  return result == true;
}

Future<bool> showOpenWizardDialog(BuildContext context) async {
  final ds = context.ds;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text(
          'Abrir assistente?',
          style: ds.typography.headingMedium,
        ),
        content: Text(
          'As etapas desta atividade serão mostradas uma a uma.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancelar', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Abrir', style: ds.typography.label),
          ),
        ],
      );
    },
  );
  return result == true;
}

Future<bool> showCompleteActivityDialog(BuildContext context) async {
  final ds = context.ds;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text(
          'Concluir atividade?',
          style: ds.typography.headingMedium,
        ),
        content: Text(
          'Esta atividade será registrada como concluída e movida para o histórico.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancelar', style: ds.typography.label),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Concluir', style: ds.typography.label),
          ),
        ],
      );
    },
  );
  return result == true;
}
