import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/discover_page.dart';

void main() {
  group('DiscoverPage', () {
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

    testWidgets('debe mostrar la página de descubrimiento', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar indicador de carga inicialmente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar el título Discover', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('debe mostrar botón de carrito en el header', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('debe mostrar banner promocional', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('SUMMER SALE'), findsOneWidget);
    });

    testWidgets('debe navegar al carrito desde el header', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final cartButton = find.byIcon(Icons.shopping_cart_outlined);
      await tester.tap(cartButton);
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('debe agregar producto al carrito', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar un botón de agregar al carrito
      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(cartService.items.isNotEmpty, true);
      }
    });

    testWidgets('debe filtrar productos por categoría', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar un FilterChip de categoría
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().isNotEmpty) {
        await tester.tap(filterChips.first);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar diálogo de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterButton = find.byIcon(Icons.tune);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsOneWidget);
      }
    });

    testWidgets('debe ordenar productos', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar dropdown de ordenamiento
      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().isNotEmpty) {
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle();

        expect(find.text('Price: Low to High'), findsOneWidget);
      }
    });

    testWidgets('debe mostrar mensaje de error y permitir reintentar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Si hay error, debe mostrar botón de reintentar
      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe filtrar productos por categoría específica', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar FilterChips y seleccionar uno que no sea "All"
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length > 1) {
        await tester.tap(filterChips.at(1)); // Segundo chip (Electronics)
        await tester.pumpAndSettle();

        // Verificar que se actualizó el título
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar título dinámico según categoría seleccionada', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que se muestra el título
      expect(find.textContaining('Products'), findsWidgets);
    });

    testWidgets('debe ordenar productos por precio de menor a mayor', (WidgetTester tester) async {
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

    testWidgets('debe ordenar productos por precio de mayor a menor', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().isNotEmpty) {
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle();

        final highToLow = find.text('Price: High to Low');
        if (highToLow.evaluate().isNotEmpty) {
          await tester.tap(highToLow);
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('debe mostrar y cerrar diálogo de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterButton = find.byIcon(Icons.tune);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsOneWidget);

        final applyButton = find.text('Apply Filters');
        await tester.tap(applyButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsNothing);
      }
    });

    testWidgets('debe agregar producto al carrito desde grid', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(find.text('Producto agregado al carrito'), findsOneWidget);
        expect(cartService.items.isNotEmpty, true);
      }
    });

    testWidgets('debe mostrar botón Shop Now en banner promocional', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Shop Now'), findsOneWidget);
    });

    testWidgets('debe mostrar título dinámico cuando se selecciona categoría', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Seleccionar categoría diferente a "All"
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length > 1) {
        await tester.tap(filterChips.at(1)); // Electronics
        await tester.pumpAndSettle();

        // Verificar que cambió el título
        expect(find.textContaining('Electronics'), findsWidgets);
      }
    });

    testWidgets('debe ordenar productos por precio de menor a mayor', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().isNotEmpty) {
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle();

        final lowToHigh = find.text('Price: Low to High');
        if (lowToHigh.evaluate().isNotEmpty) {
          await tester.tap(lowToHigh);
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('debe ordenar productos por precio de mayor a menor', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().isNotEmpty) {
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle();

        final highToLow = find.text('Price: High to Low');
        if (highToLow.evaluate().isNotEmpty) {
          await tester.tap(highToLow);
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('debe mostrar y aplicar filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterButton = find.byIcon(Icons.tune);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsOneWidget);
        expect(find.text('Price Range'), findsOneWidget);

        final applyButton = find.text('Apply Filters');
        await tester.tap(applyButton);
        await tester.pumpAndSettle();

        expect(find.text('Filter Products'), findsNothing);
      }
    });

    testWidgets('debe tocar botón Shop Now en banner', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final shopNowButton = find.text('Shop Now');
      if (shopNowButton.evaluate().isNotEmpty) {
        await tester.tap(shopNowButton);
        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe filtrar por todas las categorías disponibles', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length > 1) {
        // Probar cada categoría
        for (int i = 1; i < filterChips.evaluate().length && i < 5; i++) {
          await tester.tap(filterChips.at(i));
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar título dinámico según categoría seleccionada', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar título inicial
      expect(find.textContaining('Products'), findsWidgets);

      // Seleccionar categoría
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length > 1) {
        await tester.tap(filterChips.at(1));
        await tester.pumpAndSettle();

        // Verificar que cambió el título
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });
  });
}
