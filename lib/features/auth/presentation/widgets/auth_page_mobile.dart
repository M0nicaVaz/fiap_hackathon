import 'package:fiap_hackathon/app/navigation/app_routes.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/auth/presentation/pages/auth_page.dart';
import 'package:fiap_hackathon/features/auth/presentation/providers/auth_session_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthPageMobile extends StatelessWidget {
  final AuthPageProps props;

  const AuthPageMobile({super.key, required this.props});

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
                ExcludeSemantics(
                  child: Image.asset(
                    'assets/images/landing.png',
                    height: 300,
                    width: 300,
                    fit: BoxFit.contain,
                    cacheHeight: 300,
                    cacheWidth: 300,
                  ),
                ),
                SizedBox(height: ds.spacing.lg),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bem-vindo ao SeniorEase',
                    style: ds.typography.display.copyWith(
                      color: ds.colors.primary,
                    ),
                  ),
                ),
                SizedBox(height: ds.spacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sua vida organizada de forma simples e acessível.',
                  ),
                ),
                SizedBox(height: ds.spacing.xl),
                Column(
                  children: [
                    TextFormField(
                      controller: props.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          props.passwordFocus.requestFocus(),
                      decoration: const InputDecoration(
                        label: Text('Insira seu e-mail'),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(height: ds.spacing.md),
                    TextFormField(
                      controller: props.passwordController,
                      focusNode: props.passwordFocus,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (props.loading) props.onSubmit;
                      },
                      decoration: const InputDecoration(
                        label: Text('Insira sua senha'),
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    if (props.errorMessage != null) ...[
                      SizedBox(height: ds.spacing.sm),
                      Text(
                        props.errorMessage!,
                        style: ds.typography.bodyMedium.copyWith(
                          color: ds.colors.feedbackDanger,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: ds.spacing.md),
                  ],
                ),
                DSButton(
                  label: 'Entrar',
                  variant: DSButtonVariant.primary,
                  onPressed: props.onSubmit,
                  loading: props.loading,
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: "Criar conta",
                  variant: DSButtonVariant.secondary,
                  onPressed: () {
                    context.go(AppRoutes.register);
                  },
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: 'Entrar com Google',
                  variant: DSButtonVariant.ghost,
                  onPressed: props.loading
                      ? null
                      : () => context
                            .read<AuthSessionStateProvider>()
                            .enterWithGoogle(),
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
