import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../../features/profile/domain/usecases/load_accessibility_from_supabase_use_case.dart';
import '../../../../features/profile/domain/usecases/sync_accessibility_to_supabase_use_case.dart';
import '../../domain/entities/accessibility_settings.dart';
import '../../domain/usecases/load_accessibility_settings_use_case.dart';
import '../../domain/usecases/save_accessibility_settings_use_case.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';

class AccessibilityPreferencesController extends ChangeNotifier {
  AccessibilityPreferencesController({
    required LoadAccessibilitySettingsUseCase loadSettingsUseCase,
    required SaveAccessibilitySettingsUseCase saveSettingsUseCase,
    SyncAccessibilityToSupabaseUseCase? syncToSupabaseUseCase,
    LoadAccessibilityFromSupabaseUseCase? loadFromSupabaseUseCase,
    AuthRepository? authRepository,
  })  : _saveSettingsUseCase = saveSettingsUseCase,
        _syncToSupabaseUseCase = syncToSupabaseUseCase,
        _loadFromSupabaseUseCase = loadFromSupabaseUseCase,
        _authRepository = authRepository,
        _settings = loadSettingsUseCase() {
    _listenToAuth();
  }

  final SaveAccessibilitySettingsUseCase _saveSettingsUseCase;
  final SyncAccessibilityToSupabaseUseCase? _syncToSupabaseUseCase;
  final LoadAccessibilityFromSupabaseUseCase? _loadFromSupabaseUseCase;
  final AuthRepository? _authRepository;
  StreamSubscription<dynamic>? _authSub;

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
    if (_settings.fontScale == scale) return;
    _apply(_settings.copyWith(fontScale: scale));
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
    final repo = _authRepository;
    if (repo == null) return;
    _authSub = repo.authStateChanges.listen((user) {
      if (user != null) _loadFromSupabase(user.uid);
    });
  }

  Future<void> _loadFromSupabase(String uid) async {
    final useCase = _loadFromSupabaseUseCase;
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
    final uid = _authRepository?.currentUser?.uid;
    if (uid != null && _syncToSupabaseUseCase != null) {
      unawaited(_syncToSupabaseUseCase(uid, settings));
    }
  }
}
