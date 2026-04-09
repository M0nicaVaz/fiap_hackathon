import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_card/ds_card.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_section_title/ds_section_title.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_slider_tile/ds_slider_tile.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_switch_tile/ds_switch_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/accessibility_preferences_controller.dart';

class CustomizationPage extends StatelessWidget {
  const CustomizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Scaffold(
      backgroundColor: ds.colors.background,
      body: Consumer<AccessibilityPreferencesController>(
        builder: (context, controller, child) {
          return ListView(
            padding: EdgeInsets.all(ds.spacing.lg),
            children: [
              const DsSectionTitle(title: 'Visual e Leitura'),
              DsCard(
                child: Column(
                  children: [
                    DsSliderTile(
                      title: 'Tamanho da Fonte',
                      value: controller.fontScale,
                      min: 0.8,
                      max: 1.5,
                      onChanged: controller.setFontScale,
                      icon: Icons.format_size,
                    ),
                    Divider(color: ds.colors.disabled.withValues(alpha: 0.2)),
                    DsSliderTile(
                      title: 'Espaçamento entre Elementos',
                      value: controller.spacingScale,
                      min: 0.8,
                      max: 1.5,
                      onChanged: controller.setSpacingScale,
                      icon: Icons.unfold_more,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ds.spacing.lg),
              const DsSectionTitle(title: 'Contraste'),
              DsCard(
                child: RadioGroup<ColorThemeType>(
                  groupValue: controller.colorTheme,
                  onChanged: (value) {
                    if (value != null) {
                      controller.setTheme(value);
                    }
                  },
                  child: Column(
                    children: ColorThemeType.values.map((theme) {
                      return RadioListTile<ColorThemeType>(
                        title: Text(
                          _getThemeName(theme),
                          style: ds.typography.bodyMedium,
                        ),
                        value: theme,
                        contentPadding: EdgeInsets.zero,
                        activeColor: ds.colors.primary,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: ds.spacing.lg),
              const DsSectionTitle(title: 'Modo de Interface'),
              DsCard(
                child: Column(
                  children: [
                    DsSwitchTile(
                      title: 'Simplificação da Interface (Modo Básico)',
                      value: controller.isBasicMode,
                      onChanged: controller.setBasicMode,
                      icon: Icons.auto_awesome_motion,
                    ),
                    Divider(color: ds.colors.disabled.withValues(alpha: 0.2)),
                    DsSwitchTile(
                      title: 'Feedback Visual Reforçado',
                      value: controller.reinforcedFeedback,
                      onChanged: controller.setReinforcedFeedback,
                      icon: Icons.visibility,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ds.spacing.lg),
              const DsSectionTitle(title: 'Segurança'),
              DsCard(
                child: DsSwitchTile(
                  title: 'Confirmação adicional para ações críticas',
                  value: controller.additionalConfirmation,
                  onChanged: controller.setAdditionalConfirmation,
                  icon: Icons.verified_user,
                ),
              ),
              SizedBox(height: ds.spacing.xl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ds.spacing.md),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWeb = kIsWeb || constraints.maxWidth > 600;
                      return SizedBox(
                        width: isWeb
                            ? constraints.maxWidth * 0.3
                            : double.infinity,
                        child: DSButton(
                          variant: DSButtonVariant.danger,
                          onPressed: () => _handleReset(context, controller),
                          label: 'Resetar para o Padrão',
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: ds.spacing.xxl),
            ],
          );
        },
      ),
    );
  }

  void _handleReset(
    BuildContext context,
    AccessibilityPreferencesController controller,
  ) {
    if (controller.additionalConfirmation) {
      showDialog(
        context: context,
        builder: (context) {
          final ds = context.ds;
          return AlertDialog(
            backgroundColor: ds.colors.surface,
            title: Text(
              'Resetar Configurações?',
              style: ds.typography.headingMedium,
            ),
            content: Text(
              'Isso voltará todas as personalizações para o estado original.',
              style: ds.typography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar', style: ds.typography.label),
              ),
              TextButton(
                onPressed: () {
                  controller.reset();
                  Navigator.pop(context);
                },
                child: Text(
                  'Resetar',
                  style: ds.typography.label.copyWith(
                    color: ds.colors.feedbackDanger,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      controller.reset();
    }
  }

  String _getThemeName(ColorThemeType theme) {
    switch (theme) {
      case ColorThemeType.standard:
        return 'Padrão';
      case ColorThemeType.highContrast:
        return 'Alto Contraste';
      case ColorThemeType.extremeContrast:
        return 'Contraste Extremo (Alta Legibilidade)';
    }
  }
}
