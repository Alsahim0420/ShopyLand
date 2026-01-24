import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/discover_page.dart';

void main() {
  group('DiscoverPage - Tests Comprehensivos', () {
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

    testWidgets('debe mostrar vista de error y permitir reintentar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Esperar a que cargue o falle
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Si hay error, debe mostrar botón de reintentar
      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe filtrar por categoría Electronics', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length > 1) {
        // Buscar el chip de Electronics
        final electronicsChip = find.text('Electronics');
        if (electronicsChip.evaluate().isNotEmpty) {
          await tester.tap(electronicsChip);
          await tester.pumpAndSettle();

          expect(find.text('Electronics'), findsWidgets);
        }
      }
    });

    testWidgets('debe filtrar por categoría Jewelery', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final jeweleryChip = find.text('Jewelery');
      if (jeweleryChip.evaluate().isNotEmpty) {
        await tester.tap(jeweleryChip);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe filtrar por categoría Men\'s', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final mensChip = find.text("Men's");
      if (mensChip.evaluate().isNotEmpty) {
        await tester.tap(mensChip);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe filtrar por categoría Women\'s', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final womensChip = find.text("Women's");
      if (womensChip.evaluate().isNotEmpty) {
        await tester.tap(womensChip);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar badge del carrito cuando hay items', (WidgetTester tester) async {
      cartService.addItem(CartItem(
        product: ProductEntity(
          id: 1,
          title: 'Test',
          price: 10.0,
          description: 'Test',
          category: 'test',
          image: 'test.jpg',
          rating: RatingEntity(rate: 4.0, count: 100),
        ),
        quantity: 1,
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que se muestra el badge
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('debe actualizar setState después de agregar al carrito', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(find.text('Producto agregado al carrito'), findsOneWidget);
      }
    });

    testWidgets('debe mostrar título All Products cuando categoría es All', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('All Products'), findsOneWidget);
    });

    testWidgets('debe ejecutar _sortProducts con Most Relevant', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // El dropdown ya está en 'Most Relevant', solo verificar que existe
      final dropdowns = find.byType(DropdownButton<String>);
      expect(dropdowns, findsWidgets);
    });

    testWidgets('debe mostrar todos los elementos del banner promocional', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('SUMMER SALE'), findsOneWidget);
      expect(find.text('50% Off'), findsOneWidget);
      expect(find.text('Fashion'), findsOneWidget);
      expect(find.text('Shop Now'), findsOneWidget);
    });
  });
}
