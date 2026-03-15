import 'package:fiap_hackathon/core/design_system/widgets/ds_icon/ds_icon.dart';
import 'package:flutter/material.dart';

class DSIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final DSIconSize size;
  final Color? iconColor;

  const DSIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = DSIconSize.md,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: DSIcon(icon, size: size, color: iconColor),
    );
  }
}
