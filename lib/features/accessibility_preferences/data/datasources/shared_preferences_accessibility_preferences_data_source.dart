import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/accessibility_settings.dart';

class SharedPreferencesAccessibilityPreferencesDataSource {
  SharedPreferencesAccessibilityPreferencesDataSource(this._preferences);

  static const _keyFontScale = 'accessibility_font_scale';
  static const _keySpacingScale = 'accessibility_spacing_scale';
  static const _keyColorTheme = 'accessibility_color_theme';
  static const _keyIsBasicMode = 'accessibility_is_basic_mode';
  static const _keyReinforcedFeedback = 'accessibility_reinforced_feedback';
  static const _keyAdditionalConfirmation =
      'accessibility_additional_confirmation';

  final SharedPreferences _preferences;

  AccessibilitySettings loadSettings() {
    final colorThemeIndex = _preferences.getInt(_keyColorTheme) ?? 0;

    return AccessibilitySettings(
      fontScale: _preferences.getDouble(_keyFontScale) ?? 1.0,
      spacingScale: _preferences.getDouble(_keySpacingScale) ?? 1.0,
      colorTheme: ColorThemeType
          .values[colorThemeIndex.clamp(0, ColorThemeType.values.length - 1)],
      isBasicMode: _preferences.getBool(_keyIsBasicMode) ?? false,
      reinforcedFeedback: _preferences.getBool(_keyReinforcedFeedback) ?? false,
      additionalConfirmation:
          _preferences.getBool(_keyAdditionalConfirmation) ?? false,
    );
  }

  Future<void> saveSettings(AccessibilitySettings settings) async {
    await _preferences.setDouble(_keyFontScale, settings.fontScale);
    await _preferences.setDouble(_keySpacingScale, settings.spacingScale);
    await _preferences.setInt(_keyColorTheme, settings.colorTheme.index);
    await _preferences.setBool(_keyIsBasicMode, settings.isBasicMode);
    await _preferences.setBool(
      _keyReinforcedFeedback,
      settings.reinforcedFeedback,
    );
    await _preferences.setBool(
      _keyAdditionalConfirmation,
      settings.additionalConfirmation,
    );
  }
}
