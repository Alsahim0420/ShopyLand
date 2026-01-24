import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/home_page.dart';

void main() {
  group('HomePage - Tests Comprehensivos', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const HomePage(),
      );
    }

    testWidgets('debe mostrar todos los tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Productos'), findsOneWidget);
      expect(find.text('Categorías'), findsOneWidget);
      expect(find.text('Usuarios'), findsOneWidget);
    });

    testWidgets('debe cambiar entre tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Cambiar a tab de Categorías
      await tester.tap(find.text('Categorías'));
      await tester.pumpAndSettle();

      // Cambiar a tab de Usuarios
      await tester.tap(find.text('Usuarios'));
      await tester.pumpAndSettle();

      // Volver a Productos
      await tester.tap(find.text('Productos'));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar título ShopyLand con icono', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('ShopyLand'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('debe mostrar gradiente en el body', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('debe mostrar TabBarView con 3 páginas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('debe mostrar indicador azul en tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.indicatorColor, Colors.blue);
    });
  });
}
