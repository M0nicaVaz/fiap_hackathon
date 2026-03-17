import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class DsPreferencesItem extends StatelessWidget {
  final String title;
  final String? description;
  final Widget trailing;

  const DsPreferencesItem({
    super.key,
    required this.title,
    this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: ds.typography.bodyLarge)),
            trailing,
          ],
        ),
        if (description != null) ...[
          SizedBox(height: ds.spacing.xs),
          Text(description!, style: ds.typography.bodyMedium),
        ],
      ],
    );
  }
}
