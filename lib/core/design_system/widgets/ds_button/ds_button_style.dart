import 'package:flutter/material.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';

class DSButtonStyle {
  static ButtonStyle base(BuildContext context) {
    final ds = context.ds;

    return ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: ds.spacing.lg,
          vertical: ds.spacing.md,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(Size(64, ds.spacing.xxl)),
      textStyle: WidgetStatePropertyAll(ds.typography.headingMedium),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
      ),
    );
  }

  static ButtonStyle primary(BuildContext context) {
    final ds = context.ds;

    return base(context).merge(
      ElevatedButton.styleFrom(
        backgroundColor: ds.colors.primary,
        foregroundColor: ds.colors.primaryInverse,
      ),
    );
  }

  static ButtonStyle secondary(BuildContext context) {
    return base(context).merge(ElevatedButton.styleFrom());
  }

  static ButtonStyle tertiary(BuildContext context) {
    final ds = context.ds;
    return base(context).merge(
      OutlinedButton.styleFrom(
        side: BorderSide(color: ds.colors.primary, width: 2),
      ),
    );
  }

  static ButtonStyle danger(BuildContext context) {
    final ds = context.ds;

    return base(context).merge(
      ElevatedButton.styleFrom(
        backgroundColor: ds.colors.feedbackDanger,
        foregroundColor: ds.colors.feedbackDangerLight,
      ),
    );
  }

  static ButtonStyle ghost(BuildContext context) {
    final ds = context.ds;

    return base(context).merge(
      TextButton.styleFrom(
        foregroundColor: ds.colors.primary,
        padding: EdgeInsets.all(0),
      ),
    );
  }
}
