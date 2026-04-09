import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../features/auth/domain/entities/user_profile.dart';
import '../../../../features/auth/domain/usecases/get_current_user_use_case.dart';
import '../../../../features/auth/domain/usecases/watch_auth_state_use_case.dart';
import '../../domain/entities/accessibility_settings.dart';
import '../../domain/usecases/load_remote_accessibility_settings_use_case.dart';
import '../../domain/usecases/load_accessibility_settings_use_case.dart';
import '../../domain/usecases/save_accessibility_settings_use_case.dart';
import '../../domain/usecases/sync_accessibility_settings_use_case.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';

class AccessibilityPreferencesController extends ChangeNotifier {
  AccessibilityPreferencesController({
    required LoadAccessibilitySettingsUseCase loadSettingsUseCase,
    required SaveAccessibilitySettingsUseCase saveSettingsUseCase,
    SyncAccessibilitySettingsUseCase? syncAccessibilitySettingsUseCase,
    LoadRemoteAccessibilitySettingsUseCase?
    loadRemoteAccessibilitySettingsUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
    WatchAuthStateUseCase? watchAuthStateUseCase,
  }) : _saveSettingsUseCase = saveSettingsUseCase,
       _syncAccessibilitySettingsUseCase = syncAccessibilitySettingsUseCase,
       _loadRemoteAccessibilitySettingsUseCase =
           loadRemoteAccessibilitySettingsUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _watchAuthStateUseCase = watchAuthStateUseCase,
       _settings = loadSettingsUseCase() {
    _listenToAuth();
  }

  final SaveAccessibilitySettingsUseCase _saveSettingsUseCase;
  final SyncAccessibilitySettingsUseCase? _syncAccessibilitySettingsUseCase;
  final LoadRemoteAccessibilitySettingsUseCase?
  _loadRemoteAccessibilitySettingsUseCase;
  final GetCurrentUserUseCase? _getCurrentUserUseCase;
  final WatchAuthStateUseCase? _watchAuthStateUseCase;
  StreamSubscription<UserProfile?>? _authSub;
  String? _loadedRemoteSettingsForUid;

  AccessibilitySettings _settings;

  double get fontScale => _settings.fontScale;
  double get spacingScale => _settings.spacingScale;
  ColorThemeType get colorTheme => _settings.colorTheme;
  bool get isBasicMode => _settings.isBasicMode;
  bool get reinforcedFeedback => _settings.reinforcedFeedback;
  bool get additionalConfirmation => _settings.additionalConfirmation;

  void setTheme(ColorThemeType theme) {
    if (_settings.colorTheme == theme) return;
    _apply(_settings.copyWith(colorTheme: theme));
  }

  void setFontScale(double scale) {
    final clamped = scale.clamp(0.8, 1.5);
    if (_settings.fontScale == clamped) return;
    _apply(_settings.copyWith(fontScale: clamped));
  }

  void setSpacingScale(double scale) {
    if (_settings.spacingScale == scale) return;
    _apply(_settings.copyWith(spacingScale: scale));
  }

  void setBasicMode(bool isBasic) {
    if (_settings.isBasicMode == isBasic) return;
    _apply(_settings.copyWith(isBasicMode: isBasic));
  }

  void setReinforcedFeedback(bool reinforced) {
    if (_settings.reinforcedFeedback == reinforced) return;
    _apply(_settings.copyWith(reinforcedFeedback: reinforced));
  }

  void setAdditionalConfirmation(bool additional) {
    if (_settings.additionalConfirmation == additional) return;
    _apply(_settings.copyWith(additionalConfirmation: additional));
  }

  void reset() {
    _apply(AccessibilitySettings.defaults());
  }

  void _listenToAuth() {
    final currentUser = _getCurrentUserUseCase?.call();
    if (currentUser != null) {
      _loadRemoteSettingsFor(currentUser);
    }

    final watchAuthStateUseCase = _watchAuthStateUseCase;
    if (watchAuthStateUseCase == null) return;
    _authSub = watchAuthStateUseCase().listen((user) {
      if (user == null) {
        _loadedRemoteSettingsForUid = null;
        return;
      }
      _loadRemoteSettingsFor(user);
    });
  }

  void _loadRemoteSettingsFor(UserProfile user) {
    if (_loadedRemoteSettingsForUid == user.uid) return;
    _loadedRemoteSettingsForUid = user.uid;
    unawaited(_loadRemoteSettings(user.uid));
  }

  Future<void> _loadRemoteSettings(String uid) async {
    final useCase = _loadRemoteAccessibilitySettingsUseCase;
    if (useCase == null) return;
    try {
      final remote = await useCase(uid);
      if (remote != null) {
        _settings = remote;
        notifyListeners();
        unawaited(_saveSettingsUseCase(remote));
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  void _apply(AccessibilitySettings settings) {
    _settings = settings;
    notifyListeners();
    unawaited(_saveSettingsUseCase(settings));
    final uid = _getCurrentUserUseCase?.call()?.uid;
    if (uid != null && _syncAccessibilitySettingsUseCase != null) {
      unawaited(_syncAccessibilitySettingsUseCase(uid, settings));
    }
  }
}
