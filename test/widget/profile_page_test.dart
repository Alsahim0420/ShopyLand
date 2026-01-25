import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/presentation/pages/profile_page.dart';

void main() {
  group('ProfilePage', () {
    setUp(() {
      final authService = AuthService();
      authService.logout();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const ProfilePage(),
      );
    }

    testWidgets('debe mostrar la página de perfil', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('debe mostrar el email del usuario', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Debe mostrar el email o el email demo
      expect(find.textContaining('@'), findsWidgets);
    });

    testWidgets('debe mostrar opciones del menú', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('My Orders'), findsOneWidget);
    });

    testWidgets('debe mostrar botón de logout', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('debe mostrar diálogo de confirmación al hacer logout', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final logoutButton = find.text('Logout');
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Logout'), findsWidgets);
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
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

    testWidgets('debe navegar a support', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final supportButton = find.text('Support');
      await tester.tap(supportButton);
      await tester.pumpAndSettle();

      expect(find.text('Support Center'), findsOneWidget);
    });

    testWidgets('debe mostrar opciones del menú', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('My Orders'), findsOneWidget);
      expect(find.text('Shipping Address'), findsOneWidget);
      expect(find.text('Payment Methods'), findsOneWidget);
    });
  });
}
