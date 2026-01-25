import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/presentation/pages/register_page.dart';

void main() {
  group('RegisterPage', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      authService.logout();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
        },
        home: const RegisterPage(),
      );
    }

    testWidgets('debe mostrar el título Create Account', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('debe mostrar todos los campos del formulario', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('debe validar nombre vacío', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Por favor ingresa tu nombre'), findsOneWidget);
    });

    testWidgets('debe validar email vacío', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'Test User');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Por favor ingresa tu email'), findsOneWidget);
    });

    testWidgets('debe validar email inválido', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('debe validar password mínimo de 6 caracteres', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '12345');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('La contraseña debe tener al menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('debe validar que las contraseñas coincidan', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).last;

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'different123');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('debe registrar exitosamente y navegar a home', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).last;

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      // Esperar a que termine el registro
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar navegación
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('debe mostrar/ocultar password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final passwordField = find.byType(TextFormField).at(2);
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final visibilityButtons = find.byIcon(Icons.visibility_outlined);
      expect(visibilityButtons, findsWidgets);

      await tester.tap(visibilityButtons.first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsWidgets);
    });

    testWidgets('debe navegar a login page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verificar que se cerró la página de registro
      expect(find.text('Create Account'), findsNothing);
    });
  });
}
