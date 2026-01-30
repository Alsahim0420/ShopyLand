import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';

import '../../core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _error = null;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await AuthService().login(
      _email.text.trim(),
      _password.text,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (result.success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PabAuthLayout(
      title: 'ShopyLand',
      subtitle: 'Inicia sesión para continuar',
      child: PabComplexForm(
        formKey: _formKey,
        primaryButtonLabel: 'Iniciar sesión',
        secondaryButtonLabel: 'Crear cuenta',
        onPrimarySubmit: _submit,
        onSecondarySubmit: () => Navigator.pushNamed(context, '/register'),
        isLoading: _loading,
        fields: [
          if (_error != null) ...[
            PabAlert(
              message: _error!,
              variant: AlertVariant.error,
              onClose: () => setState(() => _error = null),
            ),
            const SizedBox(height: DesignTokens.spacingMD),
          ],
          PabFormFieldGroup(
            label: 'Correo electrónico',
            fields: [
              PabTextInput(
                controller: _email,
                hint: 'tu@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!v.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingLG),
          PabFormFieldGroup(
            label: 'Contraseña',
            fields: [
              PabTextInput(
                controller: _password,
                hint: '••••••••',
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  if (v.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMD),
          Align(
            alignment: Alignment.centerRight,
            child: PabBodyText(
              text: '¿Olvidaste tu contraseña?',
              size: BodyTextSize.small,
              color: DesignTokens.primary,
            ),
          ),
        ],
      ),
    );
  }
}
