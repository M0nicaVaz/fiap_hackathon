import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../auth/domain/entities/user_profile.dart';
import '../../../auth/presentation/providers/auth_session_controller.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/save_profile_use_case.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({
    required GetProfileUseCase getProfileUseCase,
    required SaveProfileUseCase saveProfileUseCase,
    required AuthSessionStateProvider authProvider,
  })  : _getProfileUseCase = getProfileUseCase,
        _saveProfileUseCase = saveProfileUseCase,
        _authProvider = authProvider {
    _authProvider.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  final GetProfileUseCase _getProfileUseCase;
  final SaveProfileUseCase _saveProfileUseCase;
  final AuthSessionStateProvider _authProvider;

  UserProfile? _profile;
  bool _loading = false;

  UserProfile? get profile => _profile;
  bool get loading => _loading;

  void _onAuthChanged() {
    final uid = _authProvider.currentUser?.uid;
    if (uid != null && _profile?.uid != uid) {
      _loadProfile(uid);
    } else if (uid == null) {
      _profile = null;
      notifyListeners();
    }
  }

  Future<void> _loadProfile(String uid) async {
    _loading = true;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase(uid) ??
          _authProvider.currentUser;
    } catch (_) {
      _profile = _authProvider.currentUser;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> save({required String displayName}) async {
    final current = _profile ?? _authProvider.currentUser;
    if (current == null) return;
    final updated = current.copyWith(displayName: displayName);
    await _saveProfileUseCase(updated);
    _profile = updated;
    notifyListeners();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }
}
