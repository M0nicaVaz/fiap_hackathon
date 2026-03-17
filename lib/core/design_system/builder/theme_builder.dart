import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme(AppDesignSystem ds) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ds.colors.background,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: ds.colors.primary,
      secondary: ds.colors.secondary,
      error: ds.colors.feedbackDanger,
      surface: ds.colors.surface,
      onPrimary: ds.colors.primaryInverse,
      onSecondary: ds.colors.secondaryInverse,
      onError: ds.colors.feedbackDangerLight,
      onSurface: ds.colors.textPrimary,
    ),
    textTheme: TextTheme(
      bodySmall: ds.typography.caption,
      bodyMedium: ds.typography.bodyMedium,
      bodyLarge: ds.typography.bodyLarge,

      labelSmall: ds.typography.caption,
      labelMedium: ds.typography.label,
      labelLarge: ds.typography.label,

      titleSmall: ds.typography.label,
      titleMedium: ds.typography.headingMedium,
      titleLarge: ds.typography.headingLarge,

      displaySmall: ds.typography.headingLarge,
      displayMedium: ds.typography.display,
      displayLarge: ds.typography.display,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
