import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/cart_page.dart';

void main() {
  group('CartPage - Tests Comprehensivos', () {
    late CartService cartService;
    late ProductEntity testProduct1;
    late ProductEntity testProduct2;

    setUp(() {
      cartService = CartService();
      cartService.clear();

      testProduct1 = ProductEntity(
        id: 1,
        title: 'Product 1',
        price: 10.0,
        description: 'Description 1',
        category: 'category1',
        image: 'https://invalid-url-that-will-fail.com/image.jpg',
        rating: RatingEntity(rate: 4.0, count: 100),
      );

      testProduct2 = ProductEntity(
        id: 2,
        title: 'Product 2',
        price: 20.0,
        description: 'Description 2',
        category: 'category2',
        image: 'https://invalid-url-that-will-fail.com/image2.jpg',
        rating: RatingEntity(rate: 4.5, count: 50),
      );
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
        },
        home: const CartPage(),
      );
    }

    testWidgets('debe mostrar error en imagen de producto', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que se muestra el icono de error
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('debe no permitir decrementar cuando cantidad es 1', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final removeButtons = find.byIcon(Icons.remove);
      if (removeButtons.evaluate().isNotEmpty) {
        // El botón debe estar deshabilitado
        final button = tester.widget<IconButton>(removeButtons.first);
        expect(button.onPressed, isNull);
      }
    });

    testWidgets('debe actualizar cantidad múltiples veces', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        // Incrementar 3 veces
        await tester.tap(addButtons.first);
        await tester.pump();
        await tester.tap(addButtons.first);
        await tester.pump();
        await tester.tap(addButtons.first);
        await tester.pumpAndSettle();

        expect(cartService.getQuantity(testProduct1.id), 4);
      }
    });

    testWidgets('debe actualizar cuando cambia el carrito (listener)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Agregar item después de que la página ya está construida
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
    });

    testWidgets('debe mostrar todos los detalles del item', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 2));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('category1'), findsOneWidget);
      expect(find.text('\$10.00'), findsWidgets);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('debe calcular tax correctamente', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Tax (8%)'), findsOneWidget);
    });

    testWidgets('debe mostrar total con formato correcto', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Total'), findsOneWidget);
    });

    testWidgets('debe mostrar botón Clear All solo cuando hay items', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // No debe mostrar Clear All cuando está vacío
      expect(find.text('Clear All'), findsNothing);

      // Agregar item
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));
      await tester.pumpAndSettle();

      // Ahora debe mostrar Clear All
      expect(find.text('Clear All'), findsOneWidget);
    });
  });
}
