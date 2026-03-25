import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
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
    final ds = context.ds;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ds.spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: ds.spacing.lg),
                Image.asset(
                  'assets/images/landing.png',
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                  cacheHeight: 300,
                  cacheWidth: 300,
                ),
                SizedBox(height: ds.spacing.lg),
                Text(
                  'Bem-vindo ao SeniorEase',
                  style: ds.typography.display.copyWith(
                    color: ds.colors.primary,
                  ),
                ),
                SizedBox(height: ds.spacing.sm),
                Text('Sua vida organizada de forma simples e acessível.'),
                SizedBox(height: ds.spacing.xl),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("Insira seu e-mail"),
                        ),
                      ),
                      SizedBox(height: ds.spacing.md),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("Insira sua senha"),
                        ),
                      ),
                      SizedBox(height: ds.spacing.xxl),
                    ],
                  ),
                ),
                DSButton(
                  label: "Entrar",
                  variant: DSButtonVariant.primary,
                  onPressed: () async {
                    await context.read<AuthSessionStateProvider>().enter();
                    if (context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: "Criar conta",
                  variant: DSButtonVariant.secondary,
                  onPressed: () async {
                    await context.read<AuthSessionStateProvider>().enter();
                    if (context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
