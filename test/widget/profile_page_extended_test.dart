import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/presentation/pages/profile_page.dart';

void main() {
  group('ProfilePage - Funcionalidades Extendidas', () {
    setUp(() {
      final authService = AuthService();
      authService.logout();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login')),
          '/support': (context) => const Scaffold(body: Text('Support')),
        },
        home: const ProfilePage(),
      );
    }

    testWidgets('debe mostrar todas las opciones del menú', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('My Orders'), findsOneWidget);
      expect(find.text('Shipping Address'), findsOneWidget);
      expect(find.text('Payment Methods'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar My Orders', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final myOrdersButton = find.text('My Orders');
      await tester.tap(myOrdersButton);
      await tester.pump();

      expect(find.text('Funcionalidad en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Shipping Address', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final shippingButton = find.text('Shipping Address');
      await tester.tap(shippingButton);
      await tester.pump();

      expect(find.text('Funcionalidad en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Payment Methods', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final paymentButton = find.text('Payment Methods');
      await tester.tap(paymentButton);
      await tester.pump();

      expect(find.text('Funcionalidad en desarrollo'), findsOneWidget);
    });

    testWidgets('debe navegar a support', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final supportButton = find.text('Support');
      await tester.tap(supportButton);
      await tester.pumpAndSettle();

      expect(find.text('Support'), findsOneWidget);
    });

    testWidgets('debe hacer logout y navegar a login', (WidgetTester tester) async {
      // Primero hacer login
      final authService = AuthService();
      await authService.loginWithDemo();

      await tester.pumpWidget(createWidgetUnderTest());

      final logoutButton = find.text('Logout');
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // Confirmar logout
      final confirmLogoutButton = find.text('Logout').last;
      await tester.tap(confirmLogoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      expect(authService.isAuthenticated, false);
    });

    testWidgets('debe cancelar logout', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final logoutButton = find.text('Logout');
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      final cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('debe mostrar botón de más opciones', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });
  });
}
