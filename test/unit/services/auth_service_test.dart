import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
    authService.logout();
  });

  group('AuthService', () {
    test('debe inicializar sin autenticación', () {
      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
    });

    test('debe hacer login con credenciales demo exitosamente', () async {
      final result = await authService.loginWithDemo();

      expect(result.success, true);
      expect(result.userEmail, AuthService.demoEmail);
      expect(authService.isAuthenticated, true);
      expect(authService.currentUser, AuthService.demoEmail);
    });

    test('debe hacer login con email y password correctos', () async {
      final result = await authService.login(
        AuthService.demoEmail,
        AuthService.demoPassword,
      );

      expect(result.success, true);
      expect(result.userEmail, AuthService.demoEmail);
      expect(authService.isAuthenticated, true);
      expect(authService.currentUser, AuthService.demoEmail);
    });

    test('debe fallar con credenciales incorrectas', () async {
      final result = await authService.login('wrong@email.com', 'wrongpass');

      expect(result.success, false);
      expect(result.message, 'Credenciales incorrectas');
      expect(authService.isAuthenticated, false);
    });

    test('debe fallar con email vacío', () async {
      final result = await authService.login('', AuthService.demoPassword);

      expect(result.success, false);
      expect(result.message, 'Por favor completa todos los campos');
      expect(authService.isAuthenticated, false);
    });

    test('debe fallar con password vacío', () async {
      final result = await authService.login(AuthService.demoEmail, '');

      expect(result.success, false);
      expect(result.message, 'Por favor completa todos los campos');
      expect(authService.isAuthenticated, false);
    });

    test('debe cerrar sesión correctamente', () async {
      await authService.loginWithDemo();
      expect(authService.isAuthenticated, true);

      authService.logout();
      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
    });

    test('debe mantener el estado de autenticación después de login exitoso',
        () async {
      await authService.loginWithDemo();
      expect(authService.isAuthenticated, true);

      // Verificar que el estado persiste
      expect(authService.currentUser, AuthService.demoEmail);
    });
  });

  group('AuthResult', () {
    test('debe crear un resultado exitoso', () {
      final result = AuthResult.success('test@example.com');

      expect(result.success, true);
      expect(result.userEmail, 'test@example.com');
      expect(result.message, isNull);
    });

    test('debe crear un resultado de fallo', () {
      final result = AuthResult.failure('Error de autenticación');

      expect(result.success, false);
      expect(result.message, 'Error de autenticación');
      expect(result.userEmail, isNull);
    });
  });
}
