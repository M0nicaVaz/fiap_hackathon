import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings {
  final double fontScale;
  final double spacingScale;
  final ColorThemeType colorTheme;
  final bool isBasicMode;
  final bool reinforcedFeedback;
  final bool additionalConfirmation;

  AccessibilitySettings({
    required this.fontScale,
    required this.spacingScale,
    required this.colorTheme,
    required this.isBasicMode,
    required this.reinforcedFeedback,
    required this.additionalConfirmation,
  });
}

class AccessibilityRepository {
  static const _keyFontScale = 'accessibility_font_scale';
  static const _keySpacingScale = 'accessibility_spacing_scale';
  static const _keyColorTheme = 'accessibility_color_theme';
  static const _keyIsBasicMode = 'accessibility_is_basic_mode';
  static const _keyReinforcedFeedback = 'accessibility_reinforced_feedback';
  static const _keyAdditionalConfirmation = 'accessibility_additional_confirmation';

  final SharedPreferences _prefs;

  AccessibilityRepository(this._prefs);

  Future<void> saveSettings(AccessibilitySettings settings) async {
    await _prefs.setDouble(_keyFontScale, settings.fontScale);
    await _prefs.setDouble(_keySpacingScale, settings.spacingScale);
    await _prefs.setInt(_keyColorTheme, settings.colorTheme.index);
    await _prefs.setBool(_keyIsBasicMode, settings.isBasicMode);
    await _prefs.setBool(_keyReinforcedFeedback, settings.reinforcedFeedback);
    await _prefs.setBool(_keyAdditionalConfirmation, settings.additionalConfirmation);
  }

  AccessibilitySettings loadSettings() {
    final fontScale = _prefs.getDouble(_keyFontScale) ?? 1.0;
    final spacingScale = _prefs.getDouble(_keySpacingScale) ?? 1.0;
    final colorThemeIndex = _prefs.getInt(_keyColorTheme) ?? 0;
    final isBasicMode = _prefs.getBool(_keyIsBasicMode) ?? false;
    final reinforcedFeedback = _prefs.getBool(_keyReinforcedFeedback) ?? false;
    final additionalConfirmation = _prefs.getBool(_keyAdditionalConfirmation) ?? false;

    return AccessibilitySettings(
      fontScale: fontScale,
      spacingScale: spacingScale,
      colorTheme: ColorThemeType.values[colorThemeIndex.clamp(0, ColorThemeType.values.length - 1)],
      isBasicMode: isBasicMode,
      reinforcedFeedback: reinforcedFeedback,
      additionalConfirmation: additionalConfirmation,
    );
  }
}
