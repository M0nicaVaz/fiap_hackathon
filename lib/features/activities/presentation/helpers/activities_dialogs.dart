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

Future<void> showTaskActionMenuDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  VoidCallback? onWizard,
  VoidCallback? onComplete,
}) async {
  final ds = context.ds;
  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: ds.colors.surface,
        title: Text(title, style: ds.typography.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onWizard != null) ...[
              DSButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onWizard();
                },
                label: 'Abrir Guia Passo a Passo',
                icon: Icons.route,
              ),
              SizedBox(height: ds.spacing.md),
            ],
            if (onComplete != null) ...[
              DSButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onComplete();
                },
                label: 'Concluir Atividade',
                icon: Icons.celebration,
              ),
              SizedBox(height: ds.spacing.md),
            ],
            DSButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onEdit();
              },
              label: 'Editar',
              icon: Icons.edit,
              variant: DSButtonVariant.secondary,
            ),
            SizedBox(height: ds.spacing.md),
            DSButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onDelete();
              },
              label: 'Excluir',
              icon: Icons.delete_outline,
              variant: DSButtonVariant.danger,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Fechar', style: ds.typography.label),
          ),
        ],
      );
    },
  );
}
