import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/di/container_registry.dart';
import 'app/navigation/app_router.dart';
import 'app/presentation/providers/home_example_provider.dart';
import 'features/auth/presentation/providers/auth_session_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ContainerRegistry.setup();

  runApp(const SeniorEaseApp());
}

class SeniorEaseApp extends StatefulWidget {
  const SeniorEaseApp({super.key});

  @override
  State<SeniorEaseApp> createState() => _SeniorEaseAppState();
}

class _SeniorEaseAppState extends State<SeniorEaseApp> {
  late final AuthSessionController _authSessionController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authSessionController = ContainerRegistry.get<AuthSessionController>();
    _router = AppRouter(authSessionProvider: _authSessionController).router;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<AuthSessionStateProvider>.value(
          value: _authSessionController,
        ),
        ChangeNotifierProvider<HomeExampleProvider>(
          create: (_) => HomeExampleProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'SeniorEase',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF125B50)),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
