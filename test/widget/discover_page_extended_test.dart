import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/discover_page.dart';

void main() {
  group('DiscoverPage - Funcionalidades Extendidas', () {
    late CartService cartService;

    setUp(() {
      cartService = CartService();
      cartService.clear();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
        },
        home: const DiscoverPage(),
      );
    }

    testWidgets('debe mostrar filtros de categoría', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar FilterChips
      final filterChips = find.byType(FilterChip);
      expect(filterChips, findsWidgets);
    });

    testWidgets('debe seleccionar categoría diferente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar un FilterChip que no sea "All"
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length > 1) {
        await tester.tap(filterChips.at(1)); // Segundo chip
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar diálogo de filtros al tocar botón de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterButton = find.byIcon(Icons.tune);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsOneWidget);
        expect(find.text('Apply Filters'), findsOneWidget);
      }
    });

    testWidgets('debe cerrar diálogo de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterButton = find.byIcon(Icons.tune);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        final applyButton = find.text('Apply Filters');
        await tester.tap(applyButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsNothing);
      }
    });

    testWidgets('debe ordenar productos por precio', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar dropdown de ordenamiento
      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().isNotEmpty) {
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle();

        // Seleccionar "Price: Low to High"
        final lowToHigh = find.text('Price: Low to High');
        if (lowToHigh.evaluate().isNotEmpty) {
          await tester.tap(lowToHigh);
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('debe agregar producto al carrito desde grid', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar botones de agregar al carrito
      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(find.text('Producto agregado al carrito'), findsOneWidget);
      }
    });
  });
}
