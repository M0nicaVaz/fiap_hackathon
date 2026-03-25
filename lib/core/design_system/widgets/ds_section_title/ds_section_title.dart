import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class DsSectionTitle extends StatelessWidget {
  final String title;

  const DsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Padding(
      padding: EdgeInsets.only(bottom: ds.spacing.sm, left: ds.spacing.xs),
      child: Text(
        title.toUpperCase(),
        style: ds.typography.label.copyWith(
          color: ds.colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
