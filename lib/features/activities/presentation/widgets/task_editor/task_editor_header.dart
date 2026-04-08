import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class TaskEditorHeader extends StatelessWidget {
  const TaskEditorHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ds.spacing.md,
        vertical: ds.spacing.sm,
      ),
      child: Row(
        children: [
          Material(
            color: ds.colors.feedbackInfoLight,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: ds.colors.primary),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: ds.typography.headingMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: ds.colors.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person_outline, color: ds.colors.primary),
          ),
        ],
      ),
    );
  }
}
