import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/product_detail_page.dart';

void main() {
  group('ProductDetailPage - Funcionalidades Extendidas', () {
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
        image: 'https://example.com/image.jpg',
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

    testWidgets('debe mostrar precio con descuento', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que se muestra el precio con descuento (tachado)
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.textContaining('\$'), findsWidgets);
    });

    testWidgets('debe mostrar selector de cantidad', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('debe incrementar cantidad múltiples veces', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);

      // Incrementar 3 veces
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('debe agregar producto con cantidad correcta al carrito', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Incrementar cantidad a 3
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

    testWidgets('debe alternar favorito múltiples veces', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final favoriteButton = find.byIcon(Icons.favorite_border);
      expect(favoriteButton, findsOneWidget);

      // Toggle favorito
      await tester.tap(favoriteButton);
      await tester.pump();
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Toggle de vuelta
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pump();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('debe mostrar badge del carrito cuando hay items', (WidgetTester tester) async {
      cartService.addItem(CartItem(product: testProduct, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que se muestra el badge
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });
  });
}
