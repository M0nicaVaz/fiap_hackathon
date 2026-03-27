import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/usecases/check_session_use_case.dart';
import '../../domain/usecases/enter_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';

enum AuthSessionStatus { unknown, unauthenticated, authenticated }

abstract interface class AuthSessionStateProvider implements Listenable {
  AuthSessionStatus get status;

  String? get errorMessage;

  Future<void> enter();

  Future<void> signOut();
}

class AuthSessionController extends ChangeNotifier
    implements AuthSessionStateProvider {
  AuthSessionController({
    required CheckSessionUseCase checkSessionUseCase,
    required EnterUseCase enterUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _checkSessionUseCase = checkSessionUseCase,
       _enterUseCase = enterUseCase,
       _signOutUseCase = signOutUseCase {
    _bootstrapTimer = Timer(const Duration(milliseconds: 400), _bootstrap);
  }

  final CheckSessionUseCase _checkSessionUseCase;
  final EnterUseCase _enterUseCase;
  final SignOutUseCase _signOutUseCase;

  Timer? _bootstrapTimer;
  AuthSessionStatus _status = AuthSessionStatus.unknown;

  @override
  AuthSessionStatus get status => _status;

  @override
  String? get errorMessage => null;

  void _bootstrap() {
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
  }

  @override
  Future<void> enter() async {
    await _enterUseCase();
    _status = AuthSessionStatus.authenticated;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    await _signOutUseCase();
    _status = AuthSessionStatus.unauthenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _bootstrapTimer?.cancel();
    super.dispose();
  }
}
