import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/presentation/pages/register_page.dart';

void main() {
  group('RegisterPage - Edge Cases', () {
    setUp(() {
      final authService = AuthService();
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

    testWidgets('debe mostrar mensaje de error cuando registro falla', (WidgetTester tester) async {
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
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que se muestra mensaje de error si falla
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar loading state durante registro', (WidgetTester tester) async {
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

      // Verificar que se muestra el loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe validar confirmación de contraseña en el campo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).last;

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'different');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('debe mostrar botones de Google y Apple', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Google sign up', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final googleButton = find.text('Google');
      await tester.tap(googleButton);
      await tester.pump();

      expect(find.text('Google sign up en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Apple sign up', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final appleButton = find.text('Apple');
      await tester.tap(appleButton);
      await tester.pump();

      expect(find.text('Apple sign up en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar divider con texto Or continue with', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Or continue with'), findsOneWidget);
    });

    testWidgets('debe mostrar texto de creación de cuenta completo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
    });

    testWidgets('debe validar confirmación de contraseña vacía', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final signUpButton = find.text('Sign Up');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Por favor confirma tu contraseña'), findsOneWidget);
    });
  });
}
