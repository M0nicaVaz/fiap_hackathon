import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter/material.dart';

const double _kFormWidth = 480.0;

class AuthPageWeb extends StatelessWidget {
  final AuthPageProps props;

  const AuthPageWeb({super.key, required this.props});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Scaffold(
      body: Row(
        children: [
          Expanded(child: AuthBrandingPanel(ds: ds)),
          SizedBox(
            width: _kFormWidth,
            child: _AuthFormPanel(props: props, ds: ds),
          ),
        ],
      ),
    );
  }
}

class AuthBrandingPanel extends StatelessWidget {
  final AppDesignSystem ds;

  const AuthBrandingPanel({super.key, required this.ds});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/landing_web.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),

        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xB8000000), Color(0x4D000000), Color(0x00000000)],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrandingLogo(ds: ds),
                const Spacer(),
                Text(
                  'Sua vida\norganizada.',
                  style: ds.typography.display.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Simples, acessível\ne feito para você.',
                  style: ds.typography.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.75),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandingLogo extends StatelessWidget {
  final AppDesignSystem ds;
  const _BrandingLogo({required this.ds});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.28),
              width: 0.5,
            ),
          ),
          child: const Icon(
            Icons.favorite_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'SeniorEase',
          style: ds.typography.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AuthFormPanel extends StatelessWidget {
  final AuthPageProps props;
  final AppDesignSystem ds;

  const _AuthFormPanel({required this.props, required this.ds});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ds.colors.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entrar',
                style: ds.typography.display.copyWith(
                  color: ds.colors.textPrimary,
                ),
              ),
              SizedBox(height: ds.spacing.xs),
              Text(
                'Bem-vindo de volta.',
                style: ds.typography.bodyMedium.copyWith(
                  color: ds.colors.textSecondary,
                ),
              ),

              SizedBox(height: ds.spacing.xl),

              TextFormField(
                controller: props.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => props.passwordFocus.requestFocus(),
                decoration: const InputDecoration(
                  label: Text('E-mail'),
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
                  if (!props.loading) props.onSubmit();
                },
                decoration: const InputDecoration(
                  label: Text('Senha'),
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
                ),
              ],
              SizedBox(height: ds.spacing.lg),
              DSButton(
                label: 'Entrar',
                variant: DSButtonVariant.primary,
                onPressed: props.onSubmit,
                loading: props.loading,
                fullWidth: true,
              ),
              SizedBox(height: ds.spacing.md),
              DSButton(
                label: 'Criar conta',
                variant: DSButtonVariant.secondary,
                onPressed: props.onRegister,
                fullWidth: true,
              ),
              SizedBox(height: ds.spacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: ds.typography.bodyMedium.copyWith(
                        color: ds.colors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: ds.spacing.lg),
              DSButton(
                label: 'Entrar com Google',
                variant: DSButtonVariant.ghost,
                onPressed: props.loading ? null : props.onGoogleSignIn,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
