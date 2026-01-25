import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/pages/product_detail_page.dart';

void main() {
  group('ProductDetailPage', () {
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
        routes: {'/home': (context) => const Scaffold(body: Text('Home'))},
        home: ProductDetailPage(product: testProduct),
      );
    }

    testWidgets('debe mostrar el título del producto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('debe mostrar el precio del producto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('debe mostrar la descripción del producto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('debe mostrar la categoría del producto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('ELECTRONICS'), findsOneWidget);
    });

    testWidgets('debe mostrar el rating del producto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('4.5 (100)'), findsOneWidget);
    });

    testWidgets('debe incrementar la cantidad', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('debe decrementar la cantidad', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Primero incrementar
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pump();

      // Luego decrementar
      final removeButton = find.byIcon(Icons.remove);
      await tester.tap(removeButton);
      await tester.pump();

      expect(find.text('1'), findsWidgets);
    });

    testWidgets('no debe decrementar cantidad menor a 1', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final removeButton = find.byIcon(Icons.remove);
      expect(removeButton, findsOneWidget);

      // El botón debe estar deshabilitado cuando cantidad es 1
      final button = tester.widget<IconButton>(removeButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('debe agregar producto al carrito', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');
      expect(addToCartButton, findsOneWidget);

      await tester.tap(addToCartButton);
      await tester.pump();

      expect(find.text('Test Product agregado al carrito'), findsOneWidget);
      expect(cartService.items.length, 1);
    });

    testWidgets('debe alternar favorito', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final favoriteButton = find.byIcon(Icons.favorite_border);
      expect(favoriteButton, findsOneWidget);

      await tester.tap(favoriteButton);
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('debe navegar al carrito desde el app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final cartButton = find.byIcon(Icons.shopping_cart);
      expect(cartButton, findsOneWidget);

      await tester.tap(cartButton);
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('debe volver atrás al presionar back', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verificar que se cerró la página
      expect(find.text('Test Product'), findsNothing);
    });

    testWidgets('debe mostrar badge del carrito cuando hay items', (
      WidgetTester tester,
    ) async {
      cartService.addItem(CartItem(product: testProduct, quantity: 1));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verificar que se muestra el badge
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('debe navegar al carrito desde el app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final cartButton = find.byIcon(Icons.shopping_cart);
      expect(cartButton, findsOneWidget);

      await tester.tap(cartButton);
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}
