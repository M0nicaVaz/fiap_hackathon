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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.customization),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthSessionStateProvider>().signOut();
            },
            child: const Text('Sair'),
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
          FilledButton(
            onPressed: () {
              context.read<HomeExampleProvider>().increment();
            },
            child: const Text('Disparar ação do provider'),
          ),
        ],
      ),
    );
  }
}
