import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';

void main() {
  group('Integración de Autenticación', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      authService.logout();
    });

    test('debe hacer login con credenciales demo y mantener el estado', () async {
      expect(authService.isAuthenticated, false);

      final result = await authService.loginWithDemo();

      expect(result.success, true);
      expect(authService.isAuthenticated, true);
      expect(authService.currentUser, AuthService.demoEmail);
    });

    test('debe hacer login con email y password y cerrar sesión', () async {
      final loginResult = await authService.login(
        AuthService.demoEmail,
        AuthService.demoPassword,
      );

      expect(loginResult.success, true);
      expect(authService.isAuthenticated, true);

      authService.logout();

      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
    });

    test('debe fallar con credenciales incorrectas', () async {
      final result = await authService.login('wrong@email.com', 'wrongpass');

      expect(result.success, false);
      expect(authService.isAuthenticated, false);
    });

    test('debe validar campos vacíos', () async {
      final result1 = await authService.login('', AuthService.demoPassword);
      expect(result1.success, false);
      expect(result1.message, 'Por favor completa todos los campos');

      final result2 = await authService.login(AuthService.demoEmail, '');
      expect(result2.success, false);
      expect(result2.message, 'Por favor completa todos los campos');
    });
  });
}
