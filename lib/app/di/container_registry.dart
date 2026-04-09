import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/accessibility_preferences/data/datasources/shared_preferences_accessibility_preferences_data_source.dart';
import '../../features/accessibility_preferences/data/repositories/supabase_remote_accessibility_preferences_repository.dart';
import '../../features/accessibility_preferences/data/repositories/shared_preferences_accessibility_preferences_repository.dart';
import '../../features/accessibility_preferences/domain/repositories/accessibility_preferences_repository.dart';
import '../../features/accessibility_preferences/domain/repositories/remote_accessibility_preferences_repository.dart';
import '../../features/accessibility_preferences/domain/usecases/load_remote_accessibility_settings_use_case.dart';
import '../../features/accessibility_preferences/domain/usecases/load_accessibility_settings_use_case.dart';
import '../../features/accessibility_preferences/domain/usecases/save_accessibility_settings_use_case.dart';
import '../../features/accessibility_preferences/domain/usecases/sync_accessibility_settings_use_case.dart';
import '../../features/accessibility_preferences/presentation/providers/accessibility_preferences_controller.dart';
import '../../features/activities/data/datasources/supabase_tasks_data_source.dart';
import '../../features/activities/data/datasources/tasks_local_data_source.dart';
import '../../features/activities/data/repositories/tasks_repository_impl.dart';
import '../../features/activities/domain/repositories/tasks_repository.dart';
import '../../features/activities/domain/usecases/complete_task_use_case.dart';
import '../../features/activities/domain/usecases/create_task_use_case.dart';
import '../../features/activities/domain/usecases/delete_task_use_case.dart';
import '../../features/activities/domain/usecases/get_activity_history_use_case.dart';
import '../../features/activities/domain/usecases/save_task_progress_use_case.dart';
import '../../features/activities/domain/usecases/update_task_use_case.dart';
import '../../features/activities/domain/usecases/watch_tasks_use_case.dart';
import '../../features/activities/domain/usecases/refresh_tasks_use_case.dart';
import '../../features/activities/presentation/providers/tasks_controller.dart';
import '../../features/auth/data/repositories/supabase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_session_use_case.dart';
import '../../features/auth/domain/usecases/enter_use_case.dart';
import '../../features/auth/domain/usecases/enter_with_google_use_case.dart';
import '../../features/auth/domain/usecases/get_current_user_use_case.dart';
import '../../features/auth/domain/usecases/register_use_case.dart';
import '../../features/auth/domain/usecases/sign_out_use_case.dart';
import '../../features/auth/domain/usecases/watch_auth_state_use_case.dart';
import '../../features/auth/presentation/providers/auth_session_controller.dart';
import '../../features/profile/data/repositories/supabase_profile_repository.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_use_case.dart';
import '../../features/profile/domain/usecases/save_profile_use_case.dart';
import '../../features/profile/presentation/providers/profile_controller.dart';

abstract final class ContainerRegistry {
  static final GetIt _getIt = GetIt.instance;
  static bool _isSetup = false;

  static GetIt get instance => _getIt;

  static T get<T extends Object>() => _getIt<T>();

  static Future<void> setup({required SharedPreferences preferences}) async {
    if (_isSetup) return;

    _registerCore(preferences);
    _registerFeatures();

    _isSetup = true;
  }

  static Future<void> reset() async {
    await _getIt.reset(dispose: true);
    _isSetup = false;
  }

  static void _registerCore(SharedPreferences preferences) {
    _getIt
      ..registerLazySingleton<SharedPreferences>(() => preferences)
      ..registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  }

  static void _registerFeatures() {
    _getIt
      ..registerLazySingleton<AuthRepository>(
        () => SupabaseAuthRepository(_getIt()),
      )
      ..registerLazySingleton<ProfileRepository>(
        () => SupabaseProfileRepository(_getIt()),
      )
      ..registerLazySingleton<RemoteAccessibilityPreferencesRepository>(
        () => SupabaseRemoteAccessibilityPreferencesRepository(_getIt()),
      )
      ..registerLazySingleton(() => CheckSessionUseCase(_getIt()))
      ..registerLazySingleton(() => EnterUseCase(_getIt()))
      ..registerLazySingleton(() => EnterWithGoogleUseCase(_getIt()))
      ..registerLazySingleton(() => GetCurrentUserUseCase(_getIt()))
      ..registerLazySingleton(() => RegisterUseCase(_getIt()))
      ..registerLazySingleton(() => SignOutUseCase(_getIt()))
      ..registerLazySingleton(() => WatchAuthStateUseCase(_getIt()))
      ..registerLazySingleton(() => GetProfileUseCase(_getIt()))
      ..registerLazySingleton(() => SaveProfileUseCase(_getIt()))
      ..registerLazySingleton(() => SyncAccessibilitySettingsUseCase(_getIt()))
      ..registerLazySingleton(
        () => LoadRemoteAccessibilitySettingsUseCase(_getIt()),
      )
      ..registerLazySingleton(
        () => AuthSessionController(
          checkSessionUseCase: _getIt(),
          enterUseCase: _getIt(),
          enterWithGoogleUseCase: _getIt(),
          registerUseCase: _getIt(),
          signOutUseCase: _getIt(),
          authRepository: _getIt(),
        ),
      )
      ..registerLazySingleton(
        () => ProfileController(
          getProfileUseCase: _getIt(),
          saveProfileUseCase: _getIt(),
          getCurrentUserUseCase: _getIt(),
          watchAuthStateUseCase: _getIt(),
        ),
      )
      ..registerLazySingleton(
        () => SharedPreferencesAccessibilityPreferencesDataSource(_getIt()),
      )
      ..registerLazySingleton<AccessibilityPreferencesRepository>(
        () => SharedPreferencesAccessibilityPreferencesRepository(_getIt()),
      )
      ..registerLazySingleton(() => LoadAccessibilitySettingsUseCase(_getIt()))
      ..registerLazySingleton(() => SaveAccessibilitySettingsUseCase(_getIt()))
      ..registerLazySingleton(
        () => AccessibilityPreferencesController(
          loadSettingsUseCase: _getIt(),
          saveSettingsUseCase: _getIt(),
          syncAccessibilitySettingsUseCase: _getIt(),
          loadRemoteAccessibilitySettingsUseCase: _getIt(),
          getCurrentUserUseCase: _getIt(),
          watchAuthStateUseCase: _getIt(),
        ),
      )
      ..registerLazySingleton<TasksLocalDataSource>(
        () => SupabaseTasksDataSource(_getIt()),
      )
      ..registerLazySingleton<TasksRepository>(
        () => TasksRepositoryImpl(_getIt()),
      )
      ..registerLazySingleton(() => WatchTasksUseCase(_getIt()))
      ..registerLazySingleton(() => CreateTaskUseCase(_getIt()))
      ..registerLazySingleton(() => UpdateTaskUseCase(_getIt()))
      ..registerLazySingleton(() => DeleteTaskUseCase(_getIt()))
      ..registerLazySingleton(() => CompleteTaskUseCase(_getIt()))
      ..registerLazySingleton(() => GetActivityHistoryUseCase(_getIt()))
      ..registerLazySingleton(() => SaveTaskProgressUseCase(_getIt()))
      ..registerLazySingleton(() => RefreshTasksUseCase(_getIt()))
      ..registerLazySingleton(
        () => TasksController(
          watchTasksUseCase: _getIt(),
          createTaskUseCase: _getIt(),
          updateTaskUseCase: _getIt(),
          deleteTaskUseCase: _getIt(),
          completeTaskUseCase: _getIt(),
          getActivityHistoryUseCase: _getIt(),
          saveTaskProgressUseCase: _getIt(),
          refreshTasksUseCase: _getIt(),
        ),
      );
  }
}
