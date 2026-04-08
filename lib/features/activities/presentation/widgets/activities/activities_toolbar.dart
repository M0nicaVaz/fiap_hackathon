import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';

class ActivitiesToolbar extends StatelessWidget {
  const ActivitiesToolbar({
    super.key,
    required this.isWide,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAddTask,
  });

  final bool isWide;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isWide)
          ActivitiesSearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
        if (isWide) SizedBox(height: ds.spacing.md),
        LayoutTasksPageHeader(
          title: 'Tarefas do dia',
          subtitle:
              'Gerencie seu bem-estar com uma lista clara: pendentes e concluídas.',
          onAddTask: onAddTask,
          showWideAddButton: isWide,
        ),
        if (!isWide) ...[
          SizedBox(height: ds.spacing.md),
          DSButton(
            onPressed: onAddTask,
            icon: Icons.add_task,
            label: 'Nova atividade',
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

class ActivitiesSearchBar extends StatelessWidget {
  const ActivitiesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        hintText: 'Buscar uma tarefa…',
        prefixIcon: Icon(Icons.search, color: ds.colors.textSecondary),
        filled: true,
        fillColor: ds.colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: ds.colors.disabled.withValues(alpha: 0.35),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: ds.colors.disabled.withValues(alpha: 0.35),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ds.spacing.lg,
          vertical: ds.spacing.md,
        ),
      ),
    );
  }
}
