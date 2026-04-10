import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class RegisterPageMobile extends StatelessWidget {
  final RegisterPageProps props;

  const RegisterPageMobile({super.key, required this.props});

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
                    'assets/images/create_account.png',
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
                    'Criar conta',
                    style: ds.typography.display.copyWith(
                      color: ds.colors.primary,
                    ),
                  ),
                ),
                SizedBox(height: ds.spacing.sm),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Junte-se à nossa comunidade para ter tranquilidade e organizar seu dia com mais facilidade.',
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
                        label: Text('Insira sua senha'),
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
                  label: 'Criar conta',
                  onPressed: props.onSubmit,
                  loading: props.loading,
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
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
      ),
    );
  }
}
