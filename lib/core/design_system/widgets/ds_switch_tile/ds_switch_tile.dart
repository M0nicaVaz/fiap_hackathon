import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class DsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const DsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return SwitchListTile(
      title: Row(
        children: [
          Icon(icon, color: ds.colors.primary, size: ds.icons.md),
          SizedBox(width: ds.spacing.sm),
          Expanded(child: Text(title, style: ds.typography.bodyLarge)),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: ds.colors.primary,
    );
  }
}
