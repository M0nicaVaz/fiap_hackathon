import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/accessibility_settings.dart';
import '../../domain/usecases/load_accessibility_settings_use_case.dart';
import '../../domain/usecases/save_accessibility_settings_use_case.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';

class AccessibilityPreferencesController extends ChangeNotifier {
  AccessibilityPreferencesController({
    required LoadAccessibilitySettingsUseCase loadSettingsUseCase,
    required SaveAccessibilitySettingsUseCase saveSettingsUseCase,
  }) : _saveSettingsUseCase = saveSettingsUseCase,
       _settings = loadSettingsUseCase();

  final SaveAccessibilitySettingsUseCase _saveSettingsUseCase;

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

  void _apply(AccessibilitySettings settings) {
    _settings = settings;
    notifyListeners();
    unawaited(_saveSettingsUseCase(settings));
  }
}
