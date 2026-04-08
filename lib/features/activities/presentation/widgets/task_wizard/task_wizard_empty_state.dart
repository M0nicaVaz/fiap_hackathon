import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class TaskWizardEmptyState extends StatelessWidget {
  const TaskWizardEmptyState({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Scaffold(
      appBar: AppBar(title: const Text('Guia')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(ds.spacing.lg),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: ds.typography.bodyLarge,
          ),
        ),
      ),
    );
  }
}
