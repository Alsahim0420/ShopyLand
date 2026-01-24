import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/presentation/pages/login_page.dart';

void main() {
  group('LoginPage', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
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

    testWidgets('debe mostrar el título Welcome Back', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('debe mostrar campos de email y password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('debe validar email vacío', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Por favor ingresa tu email'), findsOneWidget);
    });

    testWidgets('debe validar email inválido', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('debe validar password vacío', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Por favor ingresa tu contraseña'), findsOneWidget);
    });

    testWidgets('debe hacer login exitoso con credenciales demo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final demoButton = find.text('Login with Demo Account');
      await tester.tap(demoButton);
      await tester.pump();

      // Esperar a que termine el login
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar navegación
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('debe hacer login exitoso con email y password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, AuthService.demoEmail);
      await tester.enterText(passwordField, AuthService.demoPassword);
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Esperar a que termine el login
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar navegación
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('debe mostrar error con credenciales incorrectas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'wrong@email.com');
      await tester.enterText(passwordField, 'wrongpass');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pump();

      // Esperar a que termine el login
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Credenciales incorrectas'), findsOneWidget);
    });

    testWidgets('debe mostrar/ocultar password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final visibilityButton = find.byIcon(Icons.visibility_outlined);
      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('debe navegar a register page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('debe mostrar botón de forgot password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final forgotPasswordButton = find.text('Forgot Password?');
      expect(forgotPasswordButton, findsOneWidget);

      await tester.tap(forgotPasswordButton);
      await tester.pump();

      expect(find.text('Funcionalidad en desarrollo'), findsOneWidget);
    });
  });
}
