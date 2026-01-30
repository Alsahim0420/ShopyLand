import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';

import '../../core/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _error = null;
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }
    setState(() => _loading = true);
    final result = await AuthService().login(_email.text.trim(), _password.text);
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
      title: 'Crear cuenta',
      subtitle: 'Regístrate en ShopyLand',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              PabAlert(
                message: _error!,
                variant: AlertVariant.error,
                onClose: () => setState(() => _error = null),
              ),
              const SizedBox(height: DesignTokens.spacingMD),
            ],
            PabFormFieldGroup(
              label: 'Correo',
              fields: [
                PabTextInput(
                  controller: _email,
                  hint: 'tu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu correo';
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
                    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLG),
            PabFormFieldGroup(
              label: 'Confirmar contraseña',
              fields: [
                PabTextInput(
                  controller: _confirm,
                  hint: '••••••••',
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            PabPrimaryButton(
              label: 'Registrarse',
              onPressed: _submit,
              isLoading: _loading,
              isFullWidth: true,
            ),
            const SizedBox(height: DesignTokens.spacingMD),
            PabSecondaryButton(
              label: 'Ya tengo cuenta',
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
