import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/services/auth_service.dart';

void main() {
  late AuthService auth;

  setUp(() {
    auth = AuthService();
    auth.logout();
  });

  group('AuthService', () {
    test('logout deja isAuthenticated en false', () {
      auth.logout();
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
    });

    test('login con email y password válidos devuelve success', () async {
      final result = await auth.login('test@test.com', 'password1');
      expect(result.success, isTrue);
      expect(result.userEmail, 'test@test.com');
      expect(auth.isAuthenticated, isTrue);
      expect(auth.currentUser, 'test@test.com');
    });

    test('login con email vacío devuelve failure', () async {
      final result = await auth.login('', 'password1');
      expect(result.success, isFalse);
      expect(result.message, isNotNull);
      expect(auth.isAuthenticated, isFalse);
    });

    test('login con password vacío devuelve failure', () async {
      final result = await auth.login('a@b.com', '');
      expect(result.success, isFalse);
      expect(auth.isAuthenticated, isFalse);
    });

    test('login con password menor a 6 caracteres devuelve failure', () async {
      final result = await auth.login('a@b.com', '12345');
      expect(result.success, isFalse);
      expect(auth.isAuthenticated, isFalse);
    });

    test('logout limpia currentUser', () async {
      await auth.login('u@u.com', '123456');
      expect(auth.currentUser, 'u@u.com');
      auth.logout();
      expect(auth.currentUser, isNull);
      expect(auth.isAuthenticated, isFalse);
    });
  });

  group('AuthResult', () {
    test('success tiene success true y userEmail', () {
      final r = AuthResult.success('x@y.com');
      expect(r.success, isTrue);
      expect(r.userEmail, 'x@y.com');
      expect(r.message, isNull);
    });

    test('failure tiene success false y message', () {
      final r = AuthResult.failure('Error');
      expect(r.success, isFalse);
      expect(r.message, 'Error');
      expect(r.userEmail, isNull);
    });
  });
}
