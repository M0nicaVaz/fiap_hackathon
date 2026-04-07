import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_session_use_case.dart';
import '../../domain/usecases/enter_use_case.dart';
import '../../domain/usecases/enter_with_google_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';

enum AuthSessionStatus { unknown, unauthenticated, authenticated }

abstract interface class AuthSessionStateProvider implements Listenable {
  AuthSessionStatus get status;

  String? get errorMessage;

  UserProfile? get currentUser;

  Future<void> enter({required String email, required String password});

  Future<void> register({required String email, required String password});

  Future<void> enterWithGoogle();

  Future<void> signOut();
}

class AuthSessionController extends ChangeNotifier
    implements AuthSessionStateProvider {
  AuthSessionController({
    required CheckSessionUseCase checkSessionUseCase,
    required EnterUseCase enterUseCase,
    required EnterWithGoogleUseCase enterWithGoogleUseCase,
    required RegisterUseCase registerUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthRepository authRepository,
  })  : _checkSessionUseCase = checkSessionUseCase,
        _enterUseCase = enterUseCase,
        _enterWithGoogleUseCase = enterWithGoogleUseCase,
        _registerUseCase = registerUseCase,
        _signOutUseCase = signOutUseCase,
        _authRepository = authRepository {
    _init();
  }

  final CheckSessionUseCase _checkSessionUseCase;
  final EnterUseCase _enterUseCase;
  final EnterWithGoogleUseCase _enterWithGoogleUseCase;
  final RegisterUseCase _registerUseCase;
  final SignOutUseCase _signOutUseCase;
  final AuthRepository _authRepository;

  StreamSubscription<UserProfile?>? _authSub;
  AuthSessionStatus _status = AuthSessionStatus.unknown;
  String? _errorMessage;

  @override
  AuthSessionStatus get status => _status;

  @override
  String? get errorMessage => _errorMessage;

  @override
  UserProfile? get currentUser => _authRepository.currentUser;

  void _init() {
    const autoLogin = bool.fromEnvironment('DEBUG_AUTO_LOGIN');
    if (autoLogin) {
      _status = AuthSessionStatus.authenticated;
      notifyListeners();
      return;
    }

    _status = _checkSessionUseCase()
        ? AuthSessionStatus.authenticated
        : AuthSessionStatus.unauthenticated;
    notifyListeners();

    _authSub = _authRepository.authStateChanges.listen((user) {
      final next = user != null
          ? AuthSessionStatus.authenticated
          : AuthSessionStatus.unauthenticated;
      if (_status != next) {
        _status = next;
        notifyListeners();
      }
    });
  }

  @override
  Future<void> enter({required String email, required String password}) async {
    _errorMessage = null;
    try {
      await _enterUseCase(email: email, password: password);
      _status = AuthSessionStatus.authenticated;
    } catch (e) {
      _errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  @override
  Future<void> register({required String email, required String password}) async {
    _errorMessage = null;
    try {
      await _registerUseCase(email: email, password: password);
      _status = AuthSessionStatus.authenticated;
    } catch (e) {
      _errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  @override
  Future<void> enterWithGoogle() async {
    _errorMessage = null;
    try {
      await _enterWithGoogleUseCase();
    } catch (e) {
      _errorMessage = _friendlyError(e);
      notifyListeners();
    }
  }

  @override
  Future<void> signOut() async {
    await _signOutUseCase();
    _status = AuthSessionStatus.unauthenticated;
    notifyListeners();
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid') || msg.contains('credentials')) {
      return 'E-mail ou senha inválidos.';
    }
    if (msg.contains('network') || msg.contains('connection')) {
      return 'Sem conexão. Verifique sua internet.';
    }
    return 'Ocorreu um erro. Tente novamente.';
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
