import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/builder/design_system_builder.dart';
import 'package:fiap_hackathon/core/design_system/builder/theme_builder.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/di/container_registry.dart';
import 'app/navigation/app_router.dart';
import 'features/activities/presentation/providers/tasks_controller.dart';
import 'features/accessibility_preferences/presentation/providers/accessibility_preferences_controller.dart';
import 'features/auth/presentation/providers/auth_session_controller.dart';
import 'features/profile/presentation/providers/profile_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  await Supabase.initialize(
    url: 'https://vmyacifgkzsefkitjzuk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZteWFjaWZna3pzZWZraXRqenVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU1MjY0NjEsImV4cCI6MjA5MTEwMjQ2MX0.OZXgJVOmfZVwX7PJOr_dptEedE7OuB5SceDJjDSvZc4',
  );
  final prefs = await SharedPreferences.getInstance();
  await ContainerRegistry.setup(preferences: prefs);

  runApp(const SeniorEaseApp());
}

class SeniorEaseApp extends StatefulWidget {
  const SeniorEaseApp({super.key});

  @override
  State<SeniorEaseApp> createState() => _SeniorEaseAppState();
}

class _SeniorEaseAppState extends State<SeniorEaseApp> {
  late final AuthSessionController _authSessionController;
  late final AccessibilityPreferencesController _accessibilityController;
  late final TasksController _tasksController;
  late final ProfileController _profileController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authSessionController = ContainerRegistry.get<AuthSessionController>();
    _accessibilityController =
        ContainerRegistry.get<AccessibilityPreferencesController>();
    _tasksController = ContainerRegistry.get<TasksController>();
    _profileController = ContainerRegistry.get<ProfileController>();
    _router = AppRouter(authSessionProvider: _authSessionController).router;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<AuthSessionStateProvider>.value(
          value: _authSessionController,
        ),
        ChangeNotifierProvider<AccessibilityPreferencesController>.value(
          value: _accessibilityController,
        ),
        ChangeNotifierProvider<TasksController>.value(value: _tasksController),
        ChangeNotifierProvider<ProfileController>.value(
          value: _profileController,
        ),
      ],
      child: Consumer<AccessibilityPreferencesController>(
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
