import 'package:fiap_hackathon/core/design_system/layout/app_layout.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:flutter/material.dart';

class ActivitiesPageShell extends StatelessWidget {
  const ActivitiesPageShell({
    super.key,
    required this.toolbar,
    required this.summary,
    required this.content,
    required this.showFab,
    required this.onAddTask,
    this.footer,
  });

  final Widget toolbar;
  final Widget summary;
  final Widget content;
  final bool showFab;
  final VoidCallback onAddTask;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Scaffold(
      backgroundColor: ds.colors.background,
      body: ColoredBox(
        color: ds.colors.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: isWide ? ds.spacing.xl : 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: ds.spacing.md),
                      LayoutPageContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            toolbar,
                            SizedBox(height: ds.spacing.lg),
                            summary,
                            SizedBox(height: ds.spacing.lg),
                            content,
                            ?footer,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showFab)
                  Positioned(
                    right: ds.spacing.lg,
                    bottom: ds.spacing.xxl + 8,
                    child: FloatingActionButton(
                      onPressed: onAddTask,
                      backgroundColor: ds.colors.primary,
                      foregroundColor: ds.colors.primaryInverse,
                      child: Icon(Icons.add, size: ds.icons.lg * 1.25),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
