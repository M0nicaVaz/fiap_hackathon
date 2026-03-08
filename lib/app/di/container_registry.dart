import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/in_memory_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_session_use_case.dart';
import '../../features/auth/domain/usecases/enter_use_case.dart';
import '../../features/auth/domain/usecases/sign_out_use_case.dart';
import '../../features/auth/presentation/providers/auth_session_controller.dart';

abstract final class ContainerRegistry {
  static final GetIt _getIt = GetIt.instance;
  static bool _isSetup = false;

  static GetIt get instance => _getIt;

  static T get<T extends Object>() => _getIt<T>();

  static Future<void> setup() async {
    if (_isSetup) return;

    _registerCore();
    _registerPresentation();

    _isSetup = true;
  }

  static Future<void> reset() async {
    await _getIt.reset(dispose: true);
    _isSetup = false;
  }

  static void _registerCore() {
    _getIt
      ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
      ..registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
      );
  }

  static void _registerPresentation() {
    _getIt
      ..registerLazySingleton<AuthRepository>(InMemoryAuthRepository.new)
      ..registerLazySingleton(() => CheckSessionUseCase(_getIt()))
      ..registerLazySingleton(() => EnterUseCase(_getIt()))
      ..registerLazySingleton(() => SignOutUseCase(_getIt()))
      ..registerLazySingleton(
        () => AuthSessionController(
          checkSessionUseCase: _getIt(),
          enterUseCase: _getIt(),
          signOutUseCase: _getIt(),
        ),
      );
  }
}
