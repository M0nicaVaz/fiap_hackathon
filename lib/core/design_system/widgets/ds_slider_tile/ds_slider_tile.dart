import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon/ds_icon.dart';
import 'package:flutter/material.dart';

class DsSliderTile extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final IconData icon;

  const DsSliderTile({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DSIcon(icon, color: ds.colors.primary, size: DSIconSize.lg),
            SizedBox(width: ds.spacing.lg),
            Expanded(child: Text(title, style: ds.typography.bodyLarge)),
            Text(
              '${(value * 100).toInt()}%',
              style: ds.typography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 12,
          activeColor: ds.colors.primary,
          inactiveColor: ds.colors.disabled.withOpacity(0.3),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
