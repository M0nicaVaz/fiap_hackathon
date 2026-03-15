import 'package:flutter/material.dart';
import 'ds_button_style.dart';

enum DSButtonVariant { primary, secondary, danger, ghost }

class DSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DSButtonVariant variant;
  final bool fullWidth;
  final bool loading;
  final IconData? icon;
  final ButtonStyle? style;

  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DSButtonVariant.primary,
    this.fullWidth = false,
    this.loading = false,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = loading ? null : onPressed;

    final button = switch (variant) {
      DSButtonVariant.primary => _buildElevated(context, disabled),
      DSButtonVariant.secondary => _buildOutlined(context, disabled),
      DSButtonVariant.danger => _buildDanger(context, disabled),
      DSButtonVariant.ghost => _buildGhost(context, disabled),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildElevated(BuildContext context, VoidCallback? onPressed) {
    final style = DSButtonStyle.primary(context);

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: _buildLabel(),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: _buildLabel(),
    );
  }

  Widget _buildOutlined(BuildContext context, VoidCallback? onPressed) {
    final style = DSButtonStyle.secondary(context);

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: _buildLabel(),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: _buildLabel(),
    );
  }

  Widget _buildDanger(BuildContext context, VoidCallback? onPressed) {
    final style = DSButtonStyle.danger(context);

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: _buildLabel(),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: _buildLabel(),
    );
  }

  Widget _buildGhost(BuildContext context, VoidCallback? onPressed) {
    final style = DSButtonStyle.ghost(context);

    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: _buildLabel(),
      );
    }

    return TextButton(onPressed: onPressed, style: style, child: _buildLabel());
  }

  Widget _buildLabel() {
    if (loading) {
      return const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Text(label);
  }
}
