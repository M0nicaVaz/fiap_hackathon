import 'package:fiap_hackathon/core/design_system/accessibility/accessibility_controller.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_card/ds_card.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon_button/ds_icon_button.dart';
import 'package:fiap_hackathon/features/accessibility_preferences/presentation/widgets/ds_preferences_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccessibilityPreferencesPage extends StatelessWidget {
  const AccessibilityPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ds.colors.background,
        title: Text(
          "Acessibilidade",
          style: TextStyle(color: ds.colors.textPrimary),
        ),
        leading: DSIconButton(
          icon: Icons.arrow_back,
          iconColor: ds.colors.textPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exemplo configuração",
                    style: context.ds.typography.label,
                  ),
                  SizedBox(height: context.ds.spacing.sm),

                  Text(
                    "Exemplo cabeçalho",
                    style: context.ds.typography.headingLarge,
                  ),

                  SizedBox(height: context.ds.spacing.sm),

                  Text(
                    "É assim que o texto ficará no aplicativo.",
                    style: context.ds.typography.bodyMedium,
                  ),

                  SizedBox(height: context.ds.spacing.lg),

                  DSButton(
                    label: "Botão exemplo",
                    onPressed: () {},
                    fullWidth: true,
                  ),
                ],
              ),
            ),
            DsPreferencesItem(
              title: "Text Size",
              trailing: Chip(label: Text("Extra Large")),
            ),
            Slider(
              value: ds.scale.fontScale,
              min: 0.8,
              max: 1.6,
              onChanged: (v) =>
                  context.read<AccessibilityController>().setFontScale(v),
            ),
          ],
        ),
      ),
    );
  }
}
