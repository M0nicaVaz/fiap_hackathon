import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme(AppDesignSystem ds) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ds.colors.surface,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: ds.colors.,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
    ),
  );
}
