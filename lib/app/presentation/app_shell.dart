import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon/ds_icon.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon_button/ds_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';

import '../../features/auth/presentation/providers/auth_session_controller.dart';
import 'package:fiap_hackathon/core/design_system/accessibility/accessibility_controller.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final accessCtrl = context.watch<AccessibilityController>();
    final isBasicMode = accessCtrl.isBasicMode;

    final items = [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.task_sharp),
        selectedIcon: Icon(Icons.task_sharp),
        label: 'Atividades',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_accessibility_outlined),
        selectedIcon: Icon(Icons.settings_accessibility),
        label: 'Acessibilidade',
      ),
    ];

    final titles = ["Home", "Atividades", "Acessibilidade"];
    final currentTitle = titles[navigationShell.currentIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        Widget bodyContent = Column(
          children: [
            if (isBasicMode && navigationShell.currentIndex != 0)
              Padding(
                padding: EdgeInsets.all(ds.spacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: DSButton(
                    onPressed: () => _goBranch(0),
                    label: 'Voltar para Home',
                    icon: Icons.arrow_back,
                    variant: DSButtonVariant.primary,
                  ),
                ),
              ),
            Expanded(child: navigationShell),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            toolbarHeight:
                kToolbarHeight +
                ((ds.scale.fontScale - 1.0) * 40).clamp(0.0, 60.0),
            title: Text(currentTitle),
            actions: [
              DSIconButton(
                size: DSIconSize.lg,
                icon: Icons.logout,
                onPressed: () {
                  context.read<AuthSessionStateProvider>().signOut();
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: isMobile
              ? bodyContent
              : Row(
                  children: [
                    NavigationRail(
                      selectedIndex: navigationShell.currentIndex,
                      onDestinationSelected: _goBranch,
                      labelType: NavigationRailLabelType.all,
                      destinations: items.map((item) {
                        return NavigationRailDestination(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon,
                          label: Text(item.label),
                        );
                      }).toList(),
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: bodyContent),
                  ],
                ),
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _goBranch,
                  destinations: items,
                )
              : null,
        );
      },
    );
  }
}
