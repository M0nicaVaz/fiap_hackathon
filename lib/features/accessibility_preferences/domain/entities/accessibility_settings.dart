import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';

class AccessibilitySettings {
  const AccessibilitySettings({
    required this.fontScale,
    required this.spacingScale,
    required this.colorTheme,
    required this.isBasicMode,
    required this.reinforcedFeedback,
    required this.additionalConfirmation,
  });

  factory AccessibilitySettings.defaults() {
    return const AccessibilitySettings(
      fontScale: 1.0,
      spacingScale: 1.0,
      colorTheme: ColorThemeType.standard,
      isBasicMode: false,
      reinforcedFeedback: false,
      additionalConfirmation: false,
    );
  }

  final double fontScale;
  final double spacingScale;
  final ColorThemeType colorTheme;
  final bool isBasicMode;
  final bool reinforcedFeedback;
  final bool additionalConfirmation;

  AccessibilitySettings copyWith({
    double? fontScale,
    double? spacingScale,
    ColorThemeType? colorTheme,
    bool? isBasicMode,
    bool? reinforcedFeedback,
    bool? additionalConfirmation,
  }) {
    return AccessibilitySettings(
      fontScale: fontScale ?? this.fontScale,
      spacingScale: spacingScale ?? this.spacingScale,
      colorTheme: colorTheme ?? this.colorTheme,
      isBasicMode: isBasicMode ?? this.isBasicMode,
      reinforcedFeedback: reinforcedFeedback ?? this.reinforcedFeedback,
      additionalConfirmation:
          additionalConfirmation ?? this.additionalConfirmation,
    );
  }
}
