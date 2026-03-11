import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/model/app_colors.dart';
import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:fiap_hackathon/core/design_system/model/app_spacing.dart';
import 'package:fiap_hackathon/core/design_system/model/app_typography.dart';
import 'package:fiap_hackathon/core/design_system/tokens/spacing.dart';
import 'package:fiap_hackathon/core/design_system/tokens/typography.dart';
import 'package:flutter/material.dart';

TextStyle _textStyle({
  required double size,
  required FontWeight weight,
  required AccessibilityScale scale,
}) {
  return TextStyle(
    fontFamily: 'Open Sans',
    fontSize: size * scale.fontScale,
    fontWeight: weight,
    height: TypographyTokens.lineHeight,
    letterSpacing: TypographyTokens.letterSpacing,
  );
}

AppDesignSystem buildDesignSystem({
  required AppColors colors,
  required AccessibilityScale scale,
}) {
  return AppDesignSystem(
    colors: colors,
    spacing: AppSpacing(
      xs: SpacingTokens.xs * scale.uiScale,
      sm: SpacingTokens.sm * scale.uiScale,
      md: SpacingTokens.md * scale.uiScale,
      lg: SpacingTokens.lg * scale.uiScale,
      xl: SpacingTokens.xl * scale.uiScale,
      xxl: SpacingTokens.xxl * scale.uiScale,
      xxxl: SpacingTokens.xxxl * scale.uiScale,
    ),
    typography: AppTypography(
      caption: _textStyle(
        size: TypographyTokens.caption,
        weight: TypographyTokens.regular,
        scale: scale,
      ),
      label: _textStyle(
        size: TypographyTokens.label,
        weight: TypographyTokens.regular,
        scale: scale,
      ),
      bodyMedium: _textStyle(
        size: TypographyTokens.bodyMedium,
        weight: TypographyTokens.regular,
        scale: scale,
      ),
      bodyLarge: _textStyle(
        size: TypographyTokens.bodyLarge,
        weight: TypographyTokens.regular,
        scale: scale,
      ),
      headingMedium: _textStyle(
        size: TypographyTokens.headingMedium,
        weight: TypographyTokens.semiBold,
        scale: scale,
      ),
      headingLarge: _textStyle(
        size: TypographyTokens.headingLarge,
        weight: TypographyTokens.bold,
        scale: scale,
      ),
      display: _textStyle(
        size: TypographyTokens.display,
        weight: TypographyTokens.bold,
        scale: scale,
      ),
    ),
  );
}
