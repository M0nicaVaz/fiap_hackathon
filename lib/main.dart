import 'package:fiap_hackathon/core/data/repositories/accessibility_repository.dart';
import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/builder/design_system_builder.dart';
import 'package:fiap_hackathon/core/design_system/builder/theme_builder.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/di/container_registry.dart';
import 'app/navigation/app_router.dart';

import 'features/activities/di/activities_injection.dart';
import 'features/activities/presentation/providers/tasks_controller.dart';
import 'features/auth/presentation/providers/auth_session_controller.dart';
import 'package:fiap_hackathon/core/design_system/accessibility/accessibility_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ContainerRegistry.setup();

  final prefs = await SharedPreferences.getInstance();
  final accessibilityRepository = AccessibilityRepository(prefs);
  final initialAccessibilitySettings = accessibilityRepository.loadSettings();

  runApp(
    SeniorEaseApp(
      prefs: prefs,
      initialAccessibilitySettings: initialAccessibilitySettings,
      accessibilityRepository: accessibilityRepository,
    ),
  );
}

class SeniorEaseApp extends StatefulWidget {
  const SeniorEaseApp({
    super.key,
    required this.prefs,
    this.initialAccessibilitySettings,
    this.accessibilityRepository,
  });

  final SharedPreferences prefs;
  final AccessibilitySettings? initialAccessibilitySettings;
  final AccessibilityRepository? accessibilityRepository;

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

        ChangeNotifierProvider(
          create: (_) => AccessibilityController(
            initialSettings: widget.initialAccessibilitySettings,
            repository: widget.accessibilityRepository,
          ),
        ),
        ChangeNotifierProvider<TasksController>(
          create: (_) => createTasksController(widget.prefs),
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
              locale: const Locale('pt', 'BR'),
              supportedLocales: const [Locale('pt', 'BR')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}
