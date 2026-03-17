import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/navigation/app_routes.dart';
import '../providers/auth_session_controller.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acesso')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Entrar no SeniorEase',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DSButton(
                  label: "Entrar",
                  variant: DSButtonVariant.secondary,
                  onPressed: () async {
                    await context.read<AuthSessionStateProvider>().enter();
                    if (context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
