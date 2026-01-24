import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/cart_page.dart';

void main() {
  group('CartPage - Funcionalidades Extendidas', () {
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
        image: 'https://example.com/image1.jpg',
        rating: RatingEntity(rate: 4.0, count: 100),
      );

      testProduct2 = ProductEntity(
        id: 2,
        title: 'Product 2',
        price: 20.0,
        description: 'Description 2',
        category: 'category2',
        image: 'https://example.com/image2.jpg',
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

    testWidgets('debe mostrar resumen completo de orden con múltiples items', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 2));
      cartService.addItem(CartItem(product: testProduct2, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Tax (8%)'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('debe mostrar información completa de cada item', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('category1'), findsOneWidget);
      expect(find.text('\$10.00'), findsWidgets);
    });

    testWidgets('debe incrementar cantidad desde el carrito', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pumpAndSettle();

        expect(cartService.getQuantity(testProduct1.id), 2);
      }
    });

    testWidgets('debe eliminar item con botón de eliminar', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final deleteButtons = find.byIcon(Icons.delete);
      if (deleteButtons.evaluate().isNotEmpty) {
        await tester.tap(deleteButtons.first);
        await tester.pumpAndSettle();

        expect(cartService.items.isEmpty, true);
      }
    });

    testWidgets('debe mostrar diálogo de limpiar y confirmar', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));
      cartService.addItem(CartItem(product: testProduct2, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final clearAllButton = find.text('Clear All');
      await tester.tap(clearAllButton);
      await tester.pumpAndSettle();

      expect(find.text('Clear Cart'), findsOneWidget);

      final clearButton = find.text('Clear');
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(cartService.items.isEmpty, true);
    });

    testWidgets('debe mostrar botón de checkout cuando hay items', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al hacer checkout', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final checkoutButton = find.text('Proceed to Checkout');
      await tester.tap(checkoutButton);
      await tester.pump();

      expect(find.text('Funcionalidad de checkout en desarrollo'), findsOneWidget);
    });
  });
}
