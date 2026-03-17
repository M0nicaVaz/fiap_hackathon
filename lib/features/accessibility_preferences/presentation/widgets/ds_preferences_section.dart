import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon/ds_icon.dart';
import 'package:flutter/material.dart';

class DsPreferencesSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;

  const DsPreferencesSection({
    super.key,
    required this.title,
    this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) DSIcon(icon!),
            if (icon != null) SizedBox(width: ds.spacing.sm),
            Text(title, style: ds.typography.headingMedium),
          ],
        ),
        SizedBox(height: ds.spacing.md),
        child,
      ],
    );
  }
}
