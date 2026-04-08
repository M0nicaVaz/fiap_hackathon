import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../auth/domain/entities/user_profile.dart';
import '../../../auth/domain/usecases/get_current_user_use_case.dart';
import '../../../auth/domain/usecases/watch_auth_state_use_case.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/save_profile_use_case.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({
    required GetProfileUseCase getProfileUseCase,
    required SaveProfileUseCase saveProfileUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required WatchAuthStateUseCase watchAuthStateUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _saveProfileUseCase = saveProfileUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _watchAuthStateUseCase = watchAuthStateUseCase {
    _bootstrap();
  }

  final GetProfileUseCase _getProfileUseCase;
  final SaveProfileUseCase _saveProfileUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final WatchAuthStateUseCase _watchAuthStateUseCase;
  StreamSubscription<UserProfile?>? _authSub;
  String? _loadedProfileUid;

  UserProfile? _profile;
  bool _loading = false;

  UserProfile? get profile => _profile;
  bool get loading => _loading;

  void _bootstrap() {
    _onAuthChanged(_getCurrentUserUseCase());
    _authSub = _watchAuthStateUseCase().listen(_onAuthChanged);
  }

  void _onAuthChanged(UserProfile? user) {
    final uid = user?.uid;
    if (uid != null && _loadedProfileUid != uid) {
      _loadedProfileUid = uid;
      unawaited(_loadProfile(uid, fallback: user));
    } else if (uid == null) {
      _loadedProfileUid = null;
      _profile = null;
      notifyListeners();
    }
  }

  Future<void> _loadProfile(String uid, {UserProfile? fallback}) async {
    _loading = true;
    notifyListeners();
    try {
      _profile =
          await _getProfileUseCase(uid) ?? fallback ?? _getCurrentUserUseCase();
    } catch (_) {
      _profile = fallback ?? _getCurrentUserUseCase();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> save({required String displayName}) async {
    final current = _profile ?? _getCurrentUserUseCase();
    if (current == null) return;
    final updated = current.copyWith(displayName: displayName);
    await _saveProfileUseCase(updated);
    _profile = updated;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
