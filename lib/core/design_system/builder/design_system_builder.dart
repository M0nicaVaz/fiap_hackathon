import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/model/app_colors.dart';
import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:fiap_hackathon/core/design_system/model/app_spacing.dart';
import 'package:fiap_hackathon/core/design_system/model/app_typography.dart';
import 'package:fiap_hackathon/core/design_system/tokens/spacing.dart';
import 'package:fiap_hackathon/core/design_system/tokens/typography.dart';

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
      fontFamily: 'Open Sans',
      caption: TypographyTokens.caption * scale.fontScale,
      label: TypographyTokens.label * scale.fontScale,
      bodyMedium: TypographyTokens.bodyMedium * scale.fontScale,
      bodyLarge: TypographyTokens.bodyLarge * scale.fontScale,
      headingMedium: TypographyTokens.headingMedium * scale.fontScale,
      headingLarge: TypographyTokens.headingLarge * scale.fontScale,
      display: TypographyTokens.display * scale.fontScale,
      regular: TypographyTokens.regular,
      semiBold: TypographyTokens.semiBold,
      bold: TypographyTokens.bold,
      lineHeight: TypographyTokens.lineHeight,
      letterSpacing: TypographyTokens.letterSpacing,
    ),
  );
}
