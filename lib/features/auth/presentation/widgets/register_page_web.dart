import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/auth/presentation/pages/register_page.dart';
import 'package:fiap_hackathon/features/auth/presentation/widgets/auth_page_web.dart';
import 'package:flutter/material.dart';

const double _kFormWidth = 480.0;

class RegisterPageWeb extends StatelessWidget {
  final RegisterPageProps props;

  const RegisterPageWeb({super.key, required this.props});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Scaffold(
      body: Row(
        children: [
          Expanded(child: AuthBrandingPanel(ds: ds)),
          SizedBox(
            width: _kFormWidth,
            child: _RegisterFormPanel(props: props, ds: ds),
          ),
        ],
      ),
    );
  }
}

class _RegisterFormPanel extends StatelessWidget {
  final RegisterPageProps props;
  final AppDesignSystem ds;

  const _RegisterFormPanel({required this.props, required this.ds});

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
                'Criar conta',
                style: ds.typography.display.copyWith(
                  color: ds.colors.textPrimary,
                ),
              ),
              SizedBox(height: ds.spacing.xs),
              Text(
                'Junte-se à nossa comunidade.',
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
                label: 'Criar conta',
                onPressed: props.onSubmit,
                loading: props.loading,
                fullWidth: true,
              ),
              SizedBox(height: ds.spacing.md),
              DSButton(
                label: 'Já tenho conta',
                variant: DSButtonVariant.secondary,
                onPressed: props.onLogin,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
