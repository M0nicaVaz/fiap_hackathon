import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon/ds_icon.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon_button/ds_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../navigation/app_routes.dart';
import '../../features/auth/presentation/providers/auth_session_controller.dart';
import 'providers/home_example_provider.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            kToolbarHeight + ((ds.scale.fontScale - 1.0) * 40).clamp(0.0, 60.0),
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.activities),
            child: const Text('Atividades'),
          ),
          DSIconButton(
            size: DSIconSize.lg,
            icon: Icons.settings,
            onPressed: () => context.push(AppRoutes.customization),
          ),
          DSButton(
            variant: DSButtonVariant.ghost,
            onPressed: () {
              context.read<AuthSessionStateProvider>().signOut();
            },
            label: 'Sair',
          ),
        ],
      ),
      body: const Center(child: _HomeExampleContent()),
    );
  }
}

// TODO: adicionar a home page real do projeto... aqui é só um exemplo

class _HomeExampleContent extends StatelessWidget {
  const _HomeExampleContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeExampleProvider>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Exemplo de Home porém feia porque aqui é só config :(',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text('Resultado do provider: ${provider.clickCount}'),
          const SizedBox(height: 12),
          DSButton(
            onPressed: () {
              context.read<HomeExampleProvider>().increment();
            },
            label: 'Disparar ação do provider',
          ),
        ],
      ),
    );
  }
}
