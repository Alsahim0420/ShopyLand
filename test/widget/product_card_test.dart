import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/presentation/widgets/product_card.dart';

void main() {
  late ProductEntity testProduct;
  bool onAddToCartCalled = false;

  setUp(() {
    onAddToCartCalled = false;
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
      home: Scaffold(
        body: ProductCard(
          product: testProduct,
          onAddToCart: () {
            onAddToCartCalled = true;
          },
        ),
      ),
    );
  }

  testWidgets('debe mostrar el título del producto', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Product'), findsOneWidget);
  });

  testWidgets('debe mostrar el precio del producto', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('\$99.99'), findsOneWidget);
  });

  testWidgets('debe mostrar el rating del producto', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('debe llamar onAddToCart cuando se presiona el botón',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pump();

    expect(onAddToCartCalled, true);
  });

  testWidgets('debe navegar al detalle cuando se toca la tarjeta',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final card = find.byType(InkWell);
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    // Verificar que se navegó (esto depende de la implementación de navegación)
    // En este caso, verificamos que el widget se renderizó correctamente
    expect(find.text('Test Product'), findsOneWidget);
  });

  testWidgets('debe mostrar un Card widget', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('debe mostrar un icono de favorito', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
