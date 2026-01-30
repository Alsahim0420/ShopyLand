import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PabBaseLayout(
      title: 'Soporte',
      onAppBarBack: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PabHeading(
            text: 'Soporte y contacto',
            level: HeadingLevel.h2,
          ),
          const SizedBox(height: DesignTokens.spacingLG),
          PabBodyText(
            text:
                '¿Necesitas ayuda? Puedes contactarnos por los siguientes medios.',
            size: BodyTextSize.medium,
          ),
          const SizedBox(height: DesignTokens.spacingXL),
          PabListItem(
            title: 'Email',
            subtitle: 'soporte@shopyland.com',
            leadingIcon: Icons.email,
          ),
          PabListItem(
            title: 'Teléfono',
            subtitle: '+34 900 123 456',
            leadingIcon: Icons.phone,
          ),
          PabListItem(
            title: 'Horario',
            subtitle: 'Lun–Vie 9:00–18:00',
            leadingIcon: Icons.schedule,
          ),
          const SizedBox(height: DesignTokens.spacingXL),
          const PabDivider(),
          const SizedBox(height: DesignTokens.spacingMD),
          PabBodyText(
            text: 'ShopyLand — Tu tienda de confianza.',
            size: BodyTextSize.small,
          ),
        ],
      ),
    );
  }
}
