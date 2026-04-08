import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class TaskEditorFooterActions extends StatelessWidget {
  const TaskEditorFooterActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isSaving = false,
  });

  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Material(
      elevation: 8,
      color: ds.colors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(ds.spacing.lg),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showRow = constraints.maxWidth >= 400;
              const actionHeight = 52.0;
              final actionPadding = EdgeInsets.symmetric(
                horizontal: ds.spacing.md,
              );
              final actionShape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              );
              final cancelButton = OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(
                    showRow ? 0 : double.infinity,
                    actionHeight,
                  ),
                  maximumSize: const Size(double.infinity, actionHeight),
                  padding: actionPadding,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                  shape: actionShape,
                  side: BorderSide(
                    color: ds.colors.disabled.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: ds.typography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
              final saveButton = FilledButton.icon(
                onPressed: onSave,
                style: FilledButton.styleFrom(
                  minimumSize: Size(
                    showRow ? 0 : double.infinity,
                    actionHeight,
                  ),
                  maximumSize: const Size(double.infinity, actionHeight),
                  padding: actionPadding,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                  backgroundColor: ds.colors.primary,
                  foregroundColor: ds.colors.primaryInverse,
                  shape: actionShape,
                ),
                icon: isSaving
                    ? SizedBox(
                        width: ds.icons.md,
                        height: ds.icons.md,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ds.colors.primaryInverse,
                        ),
                      )
                    : Icon(Icons.check_circle_outline, size: ds.icons.md),
                label: Text(
                  isSaving ? 'Salvando...' : 'Salvar',
                  style: ds.typography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: ds.colors.primaryInverse,
                  ),
                ),
              );
              if (showRow) {
                return Row(
                  children: [
                    Expanded(child: cancelButton),
                    SizedBox(width: ds.spacing.md),
                    Expanded(child: saveButton),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  saveButton,
                  SizedBox(height: ds.spacing.sm),
                  cancelButton,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
