import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accessibility_preferences/presentation/pages/customization_page.dart';
import '../../features/activities/presentation/pages/activities_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_session_controller.dart';
import '../../app/features/home/pages/home_page.dart';
import '../../app/presentation/app_shell.dart';
import 'app_routes.dart';

Page<T> customPage<T>({
  required LocalKey key,
  required Widget child,
  bool fullscreenDialog = false,
}) {
  if (kIsWeb) {
    return NoTransitionPage<T>(key: key, child: child);
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.android:
      return MaterialPage<T>(
        key: key,
        child: child,
        fullscreenDialog: fullscreenDialog,
      );
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return NoTransitionPage<T>(key: key, child: child);
  }
}

class AppRouter {
  AppRouter({required AuthSessionStateProvider authSessionProvider})
    : _authSessionProvider = authSessionProvider;

  final AuthSessionStateProvider _authSessionProvider;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _authSessionProvider,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        pageBuilder: (context, state) =>
            customPage<void>(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRouteNames.auth,
        pageBuilder: (context, state) =>
            customPage<void>(key: state.pageKey, child: const AuthPage()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRouteNames.home,
                pageBuilder: (context, state) => customPage<void>(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.activities,
                name: AppRouteNames.activities,
                pageBuilder: (context, state) => customPage<void>(
                  key: state.pageKey,
                  child: const ActivitiesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customization,
                name: AppRouteNames.customization,
                pageBuilder: (context, state) => customPage<void>(
                  key: state.pageKey,
                  child: const CustomizationPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final isAtSplash = location == AppRoutes.splash;
    final isAtAuth = location == AppRoutes.auth;

    switch (_authSessionProvider.status) {
      case AuthSessionStatus.unknown:
        return isAtSplash ? null : AppRoutes.splash;
      case AuthSessionStatus.unauthenticated:
        if (!isAtAuth) {
          return AppRoutes.auth;
        }
        return null;
      case AuthSessionStatus.authenticated:
        if (isAtSplash || isAtAuth || location == AppRoutes.root) {
          return AppRoutes.home;
        }
        return null;
    }
  }
}
