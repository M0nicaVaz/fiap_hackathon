import 'package:fiap_hackathon/core/design_system/accessibility/scale.dart';
import 'package:fiap_hackathon/core/design_system/model/app_colors.dart';
import 'package:fiap_hackathon/core/design_system/model/app_spacing.dart';
import 'package:fiap_hackathon/core/design_system/model/app_typography.dart';
import 'package:fiap_hackathon/core/design_system/tokens/icons.dart';

class AppDesignSystem {
  final AppColors colors;
  final AppSpacing spacing;
  final AppTypography typography;
  final AppIcons icons;
  final AccessibilityScale scale;

  AppDesignSystem({
    required this.colors,
    required this.spacing,
    required this.typography,
    required this.icons,
    required this.scale,
  });
}
