import 'package:fiap_hackathon/core/data/repositories/accessibility_repository.dart';
import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/builder/design_system_builder.dart';
import 'package:fiap_hackathon/core/design_system/builder/theme_builder.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/di/container_registry.dart';
import 'app/navigation/app_router.dart';
import 'app/presentation/providers/home_example_provider.dart';
import 'features/auth/presentation/providers/auth_session_controller.dart';
import 'package:fiap_hackathon/core/design_system/accessibility/accessibility_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ContainerRegistry.setup();

  final prefs = await SharedPreferences.getInstance();
  final accessibilityRepository = AccessibilityRepository(prefs);
  final initialAccessibilitySettings = accessibilityRepository.loadSettings();

  runApp(SeniorEaseApp(
    initialAccessibilitySettings: initialAccessibilitySettings,
    accessibilityRepository: accessibilityRepository,
  ));
}

class SeniorEaseApp extends StatefulWidget {
  final AccessibilitySettings? initialAccessibilitySettings;
  final AccessibilityRepository? accessibilityRepository;

  const SeniorEaseApp({
    super.key,
    this.initialAccessibilitySettings,
    this.accessibilityRepository,
  });

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
        ChangeNotifierProvider(
          create: (_) => AccessibilityController(
            initialSettings: widget.initialAccessibilitySettings,
            repository: widget.accessibilityRepository,
          ),
        ),
      ],
      child: Consumer<AccessibilityController>(
        builder: (context, accessibility, _) {
          final colors = colorThemes[accessibility.colorTheme]!;

          final scale = scaleFromFont(accessibility.fontScale);

          final ds = buildDesignSystem(
            colors: colors,
            scale: scale,
            spacingScale: accessibility.spacingScale,
          );

          return DesignSystemProvider(
            ds: ds,
            child: MaterialApp.router(
              title: 'SeniorEase',
              theme: buildTheme(ds),
              routerConfig: _router,
            ),
          );
        },
      ),
    );
  }
}
