import 'package:fiap_hackathon/core/data/repositories/accessibility_repository.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:flutter/foundation.dart';

class AccessibilityController extends ChangeNotifier {
  AccessibilityController({
    AccessibilitySettings? initialSettings,
    AccessibilityRepository? repository,
  }) : _repository = repository {
    if (initialSettings != null) {
      _fontScale = initialSettings.fontScale;
      _spacingScale = initialSettings.spacingScale;
      _colorTheme = initialSettings.colorTheme;
      _isBasicMode = initialSettings.isBasicMode;
      _reinforcedFeedback = initialSettings.reinforcedFeedback;
      _additionalConfirmation = initialSettings.additionalConfirmation;
    }
  }

  final AccessibilityRepository? _repository;

  double _fontScale = 1.0;
  ColorThemeType _colorTheme = ColorThemeType.standard;
  double _spacingScale = 1.0;
  bool _isBasicMode = false;
  bool _reinforcedFeedback = false;
  bool _additionalConfirmation = false;

  double get fontScale => _fontScale;
  ColorThemeType get colorTheme => _colorTheme;
  double get spacingScale => _spacingScale;
  bool get isBasicMode => _isBasicMode;
  bool get reinforcedFeedback => _reinforcedFeedback;
  bool get additionalConfirmation => _additionalConfirmation;

  void _save() {
    _repository?.saveSettings(
      AccessibilitySettings(
        fontScale: _fontScale,
        spacingScale: _spacingScale,
        colorTheme: _colorTheme,
        isBasicMode: _isBasicMode,
        reinforcedFeedback: _reinforcedFeedback,
        additionalConfirmation: _additionalConfirmation,
      ),
    );
  }

  void setTheme(ColorThemeType theme) {
    if (_colorTheme == theme) return;

    _colorTheme = theme;
    _save();
    notifyListeners();
  }

  void setFontScale(double scale) {
    if (_fontScale == scale) return;

    _fontScale = scale;
    _save();
    notifyListeners();
  }

  void setSpacingScale(double scale) {
    if (_spacingScale == scale) return;

    _spacingScale = scale;
    _save();
    notifyListeners();
  }

  void setBasicMode(bool isBasic) {
    if (_isBasicMode == isBasic) return;

    _isBasicMode = isBasic;
    _save();
    notifyListeners();
  }

  void setReinforcedFeedback(bool reinforced) {
    if (_reinforcedFeedback == reinforced) return;

    _reinforcedFeedback = reinforced;
    _save();
    notifyListeners();
  }

  void setAdditionalConfirmation(bool additional) {
    if (_additionalConfirmation == additional) return;

    _additionalConfirmation = additional;
    _save();
    notifyListeners();
  }

  void reset() {
    _fontScale = 1.0;
    _spacingScale = 1.0;
    _colorTheme = ColorThemeType.standard;
    _isBasicMode = false;
    _reinforcedFeedback = false;
    _additionalConfirmation = false;
    _save();
    notifyListeners();
  }
}
