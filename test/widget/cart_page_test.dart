import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/cart_page.dart';

void main() {
  group('CartPage', () {
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
        home: const CartPage(),
      );
    }

    testWidgets('debe mostrar mensaje cuando el carrito está vacío', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add some products to get started'), findsOneWidget);
    });

    testWidgets('debe mostrar productos cuando hay items en el carrito', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 2));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('\$10.00'), findsWidgets);
    });

    testWidgets('debe mostrar el resumen de la orden', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));
      cartService.addItem(CartItem(product: testProduct2, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Tax'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('debe incrementar cantidad de un item', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addButtons = find.byIcon(Icons.add);
      expect(addButtons, findsWidgets);

      await tester.tap(addButtons.first);
      await tester.pumpAndSettle();

      expect(cartService.getQuantity(testProduct1.id), 2);
    });

    testWidgets('debe decrementar cantidad de un item', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 2));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final removeButtons = find.byIcon(Icons.remove);
      expect(removeButtons, findsWidgets);

      await tester.tap(removeButtons.first);
      await tester.pumpAndSettle();

      expect(cartService.getQuantity(testProduct1.id), 1);
    });

    testWidgets('debe eliminar item cuando cantidad llega a 0', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final removeButtons = find.byIcon(Icons.remove);
      await tester.tap(removeButtons.first);
      await tester.pumpAndSettle();

      expect(cartService.items.isEmpty, true);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('debe eliminar item con botón de eliminar', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final deleteButtons = find.byIcon(Icons.delete_outline);
      expect(deleteButtons, findsWidgets);

      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      expect(cartService.items.isEmpty, true);
    });

    testWidgets('debe mostrar botón Clear All cuando hay items', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Clear All'), findsOneWidget);
    });

    testWidgets('debe limpiar el carrito con Clear All', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));
      cartService.addItem(CartItem(product: testProduct2, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final clearAllButton = find.text('Clear All');
      await tester.tap(clearAllButton);
      await tester.pumpAndSettle();

      // Confirmar en el diálogo
      final confirmButton = find.text('Clear');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(cartService.items.isEmpty, true);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('debe calcular el total correctamente', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 2));
      cartService.addItem(CartItem(product: testProduct2, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Subtotal: (10 * 2) + (20 * 1) = 40
      // Tax: 40 * 0.08 = 3.2
      // Total: 43.2
      expect(find.textContaining('43.20'), findsWidgets);
    });

    testWidgets('debe mostrar botón de checkout', (WidgetTester tester) async {
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

    testWidgets('debe mostrar diálogo de confirmación al limpiar carrito', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final clearAllButton = find.text('Clear All');
      await tester.tap(clearAllButton);
      await tester.pumpAndSettle();

      expect(find.text('Clear Cart'), findsOneWidget);
      expect(find.text('Are you sure you want to clear all items from your cart?'), findsOneWidget);
    });

    testWidgets('debe cancelar limpieza del carrito', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct1, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final clearAllButton = find.text('Clear All');
      await tester.tap(clearAllButton);
      await tester.pumpAndSettle();

      final cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(cartService.items.isNotEmpty, true);
    });
  });
}
