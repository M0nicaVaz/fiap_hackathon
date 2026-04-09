import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteActivityDialog(BuildContext context) async {
  final ds = context.ds;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text('Excluir atividade?', style: ds.typography.headingMedium),
        content: Text(
          'Esta ação não pode ser desfeita.',
          style: ds.typography.bodyMedium,
        ),
        actions: [
          DSButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            label: "Cancelar",
          ),
          DSButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            label: "Excluir",
            variant: DSButtonVariant.danger,
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
        title: Text('Abrir assistente?', style: ds.typography.headingMedium),
        content: Text(
          'As etapas desta atividade serão mostradas uma a uma.',
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
            label: "Abrir",
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
        title: Text('Concluir atividade?', style: ds.typography.headingMedium),
        content: Text(
          'Esta atividade será registrada como concluída e movida para o histórico.',
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
            label: "Concluir",
          ),
        ],
      );
    },
  );
  return result == true;
}
