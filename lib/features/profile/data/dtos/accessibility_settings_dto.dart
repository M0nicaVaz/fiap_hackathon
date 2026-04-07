import '../../../../core/design_system/themes/color_themes.dart';
import '../../../../features/accessibility_preferences/domain/entities/accessibility_settings.dart';

class AccessibilitySettingsDto {
  static AccessibilitySettings fromRow(Map<String, dynamic> row) {
    return AccessibilitySettings(
      fontScale: (row['font_scale'] as num?)?.toDouble() ?? 1.0,
      spacingScale: (row['spacing_scale'] as num?)?.toDouble() ?? 1.0,
      colorTheme: _colorThemeFromString(row['color_theme'] as String?),
      isBasicMode: row['is_basic_mode'] as bool? ?? false,
      reinforcedFeedback: row['reinforced_feedback'] as bool? ?? false,
      additionalConfirmation: row['additional_confirmation'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toRow(String userId, AccessibilitySettings s) {
    return {
      'user_id': userId,
      'font_scale': s.fontScale,
      'spacing_scale': s.spacingScale,
      'color_theme': s.colorTheme.name,
      'is_basic_mode': s.isBasicMode,
      'reinforced_feedback': s.reinforcedFeedback,
      'additional_confirmation': s.additionalConfirmation,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static ColorThemeType _colorThemeFromString(String? value) {
    return ColorThemeType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ColorThemeType.standard,
    );
  }
}
