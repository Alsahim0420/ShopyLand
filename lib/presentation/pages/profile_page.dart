import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';

import '../../core/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PabHeading(text: 'Perfil', level: HeadingLevel.h2),
          const SizedBox(height: DesignTokens.spacingLG),
          if (auth.isAuthenticated) ...[
            PabListItem(
              title: auth.currentUser ?? 'Usuario',
              subtitle: 'Sesión iniciada',
              leadingIcon: Icons.person,
            ),
            const SizedBox(height: DesignTokens.spacingMD),
          ],
          PabListItem(
            title: 'Soporte y contacto',
            subtitle: 'Información de ayuda',
            leadingIcon: Icons.help_outline,
            onTap: () => Navigator.pushNamed(context, '/support'),
          ),
          const SizedBox(height: DesignTokens.spacingMD),
          if (auth.isAuthenticated)
            PabPrimaryButton(
              label: 'Cerrar sesión',
              onPressed: () {
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (r) => false,
                );
              },
              icon: Icons.logout,
              isFullWidth: true,
            )
          else
            PabPrimaryButton(
              label: 'Iniciar sesión',
              onPressed: () => Navigator.pushNamed(context, '/login'),
              icon: Icons.login,
              isFullWidth: true,
            ),
        ],
      ),
    );
  }
}
