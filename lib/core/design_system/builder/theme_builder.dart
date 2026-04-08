import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme(AppDesignSystem ds) {
  final brightness = ThemeData.estimateBrightnessForColor(ds.colors.background);

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ds.colors.background,
    brightness: brightness,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      floatingLabelStyle: TextStyle(
        fontSize: ds.typography.headingLarge.fontSize,
      ),
      labelStyle: TextStyle(fontSize: ds.typography.bodyLarge.fontSize),
      focusColor: ds.colors.primary,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ds.colors.feedbackDanger),
        borderRadius: BorderRadius.all(Radius.circular(99)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: ds.colors.disabled),
        borderRadius: BorderRadius.circular(99),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(99)),
        gapPadding: 8,
      ),
    ),
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: ds.colors.primary,
      secondary: ds.colors.secondary,
      error: ds.colors.feedbackDanger,
      surface: ds.colors.surface,
      onPrimary: ds.colors.primaryInverse,
      onSecondary: ds.colors.secondaryInverse,
      onError: ds.colors.feedbackDangerLight,
      onSurface: ds.colors.textPrimary,
    ),
    iconTheme: IconThemeData(color: ds.colors.textPrimary),
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
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ds.colors.surface,
      contentTextStyle: ds.typography.bodyMedium.copyWith(
        color: ds.colors.textPrimary,
      ),
      actionTextColor: ds.colors.primary,
      disabledActionTextColor: ds.colors.textDisabled,
      closeIconColor: ds.colors.textSecondary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ds.colors.disabled.withValues(alpha: 0.25),
        ),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: ds.spacing.lg,
        vertical: ds.spacing.md,
      ),
    ),
  );
}
