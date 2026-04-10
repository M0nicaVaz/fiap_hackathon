import 'package:fiap_hackathon/app/navigation/app_routes.dart';
import 'package:fiap_hackathon/features/auth/presentation/widgets/auth_page_mobile.dart';
import 'package:fiap_hackathon/features/auth/presentation/widgets/auth_page_web.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_session_controller.dart';

class AuthPageProps {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onRegister;
  final VoidCallback onGoogleSignIn;

  const AuthPageProps({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocus,
    required this.loading,
    required this.errorMessage,
    required this.onSubmit,
    required this.onRegister,
    required this.onGoogleSignIn,
  });
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
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

    await provider.enter(
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
    final props = AuthPageProps(
      emailController: _emailController,
      passwordController: _passwordController,
      passwordFocus: _passwordFocus,
      loading: _loading,
      errorMessage: _errorMessage,
      onSubmit: _submit,
      onRegister: () => context.go(AppRoutes.register),
      onGoogleSignIn: () =>
          context.read<AuthSessionStateProvider>().enterWithGoogle(),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return AuthPageWeb(props: props);
        }
        return AuthPageMobile(props: props);
      },
    );
  }
}
