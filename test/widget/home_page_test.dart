import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/home_page.dart';

void main() {
  group('HomePage', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const HomePage(),
      );
    }

    testWidgets('debe mostrar la página de inicio', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('ShopyLand'), findsOneWidget);
    });

    testWidgets('debe mostrar tabs de navegación', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Productos'), findsOneWidget);
      expect(find.text('Categorías'), findsOneWidget);
      expect(find.text('Usuarios'), findsOneWidget);
    });

    testWidgets('debe cambiar entre tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final categoriasTab = find.text('Categorías');
      await tester.tap(categoriasTab);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
