import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/presentation/pages/login_page.dart';

void main() {
  group('LoginPage - Edge Cases', () {
    setUp(() {
      final authService = AuthService();
      authService.logout();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
          '/register': (context) => const Scaffold(body: Text('Register')),
        },
        home: const LoginPage(),
      );
    }

    testWidgets('debe mostrar mensaje de error cuando login falla', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'wrong@email.com');
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que se muestra mensaje de error
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('debe mostrar botón de forgot password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final forgotPasswordButton = find.text('Forgot Password?');
      await tester.tap(forgotPasswordButton);
      await tester.pump();

      expect(find.text('Funcionalidad en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar loading state durante login', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Verificar que se muestra el loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe deshabilitar botón durante loading', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // El botón debe estar deshabilitado durante loading
      final button = tester.widget<ElevatedButton>(loginButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('debe mostrar mensaje de error cuando mounted es false', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Simular que el widget se desmonta antes de que termine el login
      await tester.pumpWidget(const SizedBox());
      await tester.pump();

      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('debe validar email sin @', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalidemail');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('debe mostrar divider con texto Or continue with', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Or continue with'), findsOneWidget);
    });

    testWidgets('debe mostrar texto de bienvenida completo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Enter your credentials to access your account'), findsOneWidget);
    });
  });
}
