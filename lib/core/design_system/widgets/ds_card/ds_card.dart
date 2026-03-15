import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class DsCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const DsCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Card(
      color: ds.colors.surface,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(ds.spacing.lg), child: child),
      ),
    );
  }
}
