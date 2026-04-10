import 'package:fiap_hackathon/app/navigation/app_routes.dart';
import 'package:fiap_hackathon/features/auth/presentation/providers/auth_session_controller.dart';
import 'package:fiap_hackathon/features/auth/presentation/widgets/register_page_mobile.dart';
import 'package:fiap_hackathon/features/auth/presentation/widgets/register_page_web.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPageProps {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onLogin;

  const RegisterPageProps({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocus,
    required this.loading,
    required this.errorMessage,
    required this.onSubmit,
    required this.onLogin,
  });
}

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
    final props = RegisterPageProps(
      emailController: _emailController,
      passwordController: _passwordController,
      passwordFocus: _passwordFocus,
      loading: _loading,
      errorMessage: _errorMessage,
      onSubmit: _submit,
      onLogin: () => context.go(AppRoutes.auth),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return RegisterPageWeb(props: props);
        }
        return RegisterPageMobile(props: props);
      },
    );
  }
}
