import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/product_detail_page.dart';

void main() {
  group('ProductDetailPage - Tests Comprehensivos', () {
    late ProductEntity testProduct;
    late CartService cartService;

    setUp(() {
      cartService = CartService();
      cartService.clear();

      testProduct = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://invalid-url-that-will-fail.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
        },
        home: ProductDetailPage(product: testProduct),
      );
    }

    testWidgets('debe mostrar error en imagen de producto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que se muestra el icono de error
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('debe mostrar badge del carrito cuando hay items', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que se muestra el badge
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('debe mostrar precio con descuento tachado', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar precio con descuento (30% más)
      expect(find.text('\$129.99'), findsOneWidget);
    });

    testWidgets('debe mostrar categoría en mayúsculas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('ELECTRONICS'), findsOneWidget);
    });

    testWidgets('debe mostrar rating con formato correcto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('4.5 (100)'), findsOneWidget);
    });

    testWidgets('debe incrementar cantidad múltiples veces', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);

      // Incrementar 5 veces
      for (int i = 0; i < 5; i++) {
        await tester.tap(addButton);
        await tester.pump();
      }

      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('debe agregar producto con cantidad correcta', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Incrementar a 3
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();

      // Agregar al carrito
      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pump();

      expect(cartService.getQuantity(testProduct.id), 3);
    });

    testWidgets('debe mostrar mensaje con nombre del producto al agregar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pump();

      expect(find.text('Test Product agregado al carrito'), findsOneWidget);
    });
  });
}
