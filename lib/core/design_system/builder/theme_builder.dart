import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme(AppDesignSystem ds) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ds.colors.surface,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: ds.colors.primary,
      secondary: ds.colors.secondary,
      error: ds.colors.feedbackDanger,
      surface: ds.colors.surface,
      onPrimary: ds.colors.primaryInverse,
      onSecondary: ds.colors.secondaryInverse,
      onError: ds.colors.feedbackDangerLight,
      onSurface: ds.colors.primary,
    ),
    textTheme: TextTheme(
      bodySmall: ds.typography.caption,
      labelMedium: ds.typography.label,
      bodyMedium: ds.typography.bodyMedium,
      bodyLarge: ds.typography.bodyLarge,
      titleMedium: ds.typography.headingMedium,
      titleLarge: ds.typography.headingLarge,
      displayLarge: ds.typography.display,
    ),
  );
}
