import 'package:fiap_hackathon/app/navigation/app_routes.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/features/auth/presentation/providers/auth_session_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    final provider = context.read<AuthSessionStateProvider>();
    await provider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;

    setState(() {
      _loading = false;
      _errorMessage = context.read<AuthSessionStateProvider>().errorMessage;
    });

    if (context.read<AuthSessionStateProvider>().errorMessage == null) {
      context.go(AppRoutes.home);
    }
  }

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Junte-se à nossa comunidade para ter tranquilidade e organizar seu dia com mais facilidade.',
                  ),
                ),
                SizedBox(height: ds.spacing.xl),
                Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                      decoration: const InputDecoration(
                        label: Text('Insira seu e-mail'),
                      ),
                    ),
                    SizedBox(height: ds.spacing.md),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!_loading) _submit();
                      },
                      decoration: const InputDecoration(
                        label: Text('Insira sua senha'),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: ds.spacing.sm),
                      Text(
                        _errorMessage!,
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
                  label: "Criar conta",
                  onPressed: _submit,
                  loading: _loading,
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: "Já tenho conta",
                  variant: DSButtonVariant.secondary,
                  onPressed: () => context.go(AppRoutes.auth),
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
