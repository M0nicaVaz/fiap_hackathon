import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/model/app_colors.dart';
import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:fiap_hackathon/core/design_system/model/app_spacing.dart';
import 'package:fiap_hackathon/core/design_system/model/app_typography.dart';
import 'package:fiap_hackathon/core/design_system/tokens/icons.dart';
import 'package:fiap_hackathon/core/design_system/tokens/spacing.dart';
import 'package:fiap_hackathon/core/design_system/tokens/typography.dart';
import 'package:flutter/material.dart';

TextStyle _textStyle({
  required double size,
  required FontWeight weight,
  required AccessibilityScale scale,
  required Color color,
}) {
  return TextStyle(
    fontFamily: 'Open Sans',
    fontSize: size * scale.fontScale,
    fontWeight: weight,
    height: TypographyTokens.lineHeight,
    letterSpacing: TypographyTokens.letterSpacing,
    color: color,
  );
}

AppDesignSystem buildDesignSystem({
  required AppColors colors,
  required AccessibilityScale scale,
  double spacingScale = 1.0,
}) {
  final uiScale = scale.uiScale * spacingScale;

  return AppDesignSystem(
    colors: colors,
    scale: scale,
    icons: AppIcons(
      sm: 16 * uiScale,
      md: 24 * uiScale,
      lg: 32 * uiScale,
    ),
    spacing: AppSpacing(
      xs: SpacingTokens.xs * uiScale,
      sm: SpacingTokens.sm * uiScale,
      md: SpacingTokens.md * uiScale,
      lg: SpacingTokens.lg * uiScale,
      xl: SpacingTokens.xl * uiScale,
      xxl: SpacingTokens.xxl * uiScale,
      xxxl: SpacingTokens.xxxl * uiScale,
    ),
    typography: AppTypography(
      caption: _textStyle(
        size: TypographyTokens.caption,
        weight: TypographyTokens.regular,
        scale: scale,
        color: colors.textSecondary,
      ),
      label: _textStyle(
        size: TypographyTokens.label,
        weight: TypographyTokens.regular,
        scale: scale,
        color: colors.textSecondary,
      ),
      bodyMedium: _textStyle(
        size: TypographyTokens.bodyMedium,
        weight: TypographyTokens.regular,
        scale: scale,
        color: colors.textPrimary,
      ),
      bodyLarge: _textStyle(
        size: TypographyTokens.bodyLarge,
        weight: TypographyTokens.regular,
        scale: scale,
        color: colors.textPrimary,
      ),
      headingMedium: _textStyle(
        size: TypographyTokens.headingMedium,
        weight: TypographyTokens.semiBold,
        scale: scale,
        color: colors.textPrimary,
      ),
      headingLarge: _textStyle(
        size: TypographyTokens.headingLarge,
        weight: TypographyTokens.bold,
        scale: scale,
        color: colors.textPrimary,
      ),
      display: _textStyle(
        size: TypographyTokens.display,
        weight: TypographyTokens.bold,
        scale: scale,
        color: colors.textPrimary,
      ),
    ),
  );
}
