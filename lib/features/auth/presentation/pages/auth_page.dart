import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_session_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _isRegistering = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _errorMessage = null; });
    final provider = context.read<AuthSessionStateProvider>();
    if (_isRegistering) {
      await provider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      await provider.enter(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
      _errorMessage = context.read<AuthSessionStateProvider>().errorMessage;
    });
  }

  Future<void> _enterWithGoogle() async {
    setState(() { _loading = true; _errorMessage = null; });
    await context.read<AuthSessionStateProvider>().enterWithGoogle();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _errorMessage = context.read<AuthSessionStateProvider>().errorMessage;
    });
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
                Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Insira seu e-mail'),
                      ),
                    ),
                    SizedBox(height: ds.spacing.md),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text('Insira sua senha'),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: ds.spacing.sm),
                      Text(
                        _errorMessage!,
                        style: ds.typography.bodyMedium.copyWith(color: ds.colors.feedbackDanger),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: ds.spacing.xxl),
                  ],
                ),
                DSButton(
                  label: _isRegistering ? 'Criar conta' : 'Entrar',
                  variant: DSButtonVariant.primary,
                  onPressed: _loading ? null : _submit,
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: _isRegistering
                      ? 'Já tenho uma conta'
                      : 'Criar conta',
                  variant: DSButtonVariant.secondary,
                  onPressed: _loading
                      ? null
                      : () => setState(() => _isRegistering = !_isRegistering),
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: 'Entrar com Google',
                  variant: DSButtonVariant.ghost,
                  onPressed: _loading ? null : _enterWithGoogle,
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
