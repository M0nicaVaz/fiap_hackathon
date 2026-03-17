import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

enum DSIconSize { sm, md, lg }

class DSIcon extends StatelessWidget {
  final IconData icon;
  final DSIconSize size;
  final Color? color;

  const DSIcon(this.icon, {super.key, this.size = DSIconSize.md, this.color});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    final iconSize = switch (size) {
      DSIconSize.sm => ds.icons.sm,
      DSIconSize.md => ds.icons.md,
      DSIconSize.lg => ds.icons.lg,
    };

    return Icon(icon, size: iconSize, color: color);
  }
}
