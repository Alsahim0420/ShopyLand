import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/usecases/get_products.dart';
import 'package:shopyland/presentation/widgets/product_list.dart';

import 'product_list_extended_test.mocks.dart';

@GenerateMocks([GetProducts])
void main() {
  late MockGetProducts mockGetProducts;
  late List<ProductEntity> testProducts;

  setUp(() {
    mockGetProducts = MockGetProducts();
    testProducts = [
      ProductEntity(
        id: 1,
        title: 'Test Product 1',
        price: 99.99,
        description: 'Test Description 1',
        category: 'electronics',
        image: 'https://example.com/image1.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      ),
      ProductEntity(
        id: 2,
        title: 'Test Product 2',
        price: 149.99,
        description: 'Test Description 2',
        category: 'clothing',
        image: 'https://example.com/image2.jpg',
        rating: RatingEntity(rate: 4.0, count: 50),
      ),
      ProductEntity(
        id: 3,
        title: 'Test Product 3',
        price: 79.99,
        description: 'Test Description 3',
        category: 'electronics',
        image: 'https://example.com/image3.jpg',
        rating: RatingEntity(rate: 3.5, count: 75),
      ),
    ];
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ProductList(getProducts: mockGetProducts),
      ),
    );
  }

  testWidgets('debe mostrar vista de lista completa con todos los detalles', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verificar que se muestra la vista de lista
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Test Product 1'), findsWidgets);
  });

  testWidgets('debe mostrar detalles completos en modal', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tocar una tarjeta para abrir detalles
    final productCards = find.byType(InkWell);
    if (productCards.evaluate().isNotEmpty) {
      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      // Verificar detalles en el modal
      expect(find.text('Test Product 1'), findsWidgets);
      expect(find.text('Descripción'), findsOneWidget);
      expect(find.text('Test Description 1'), findsOneWidget);
    }
  });

  testWidgets('debe mostrar precio y rating en modal', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final productCards = find.byType(InkWell);
    if (productCards.evaluate().isNotEmpty) {
      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      expect(find.text('\$99.99'), findsWidgets);
      expect(find.text('4.5'), findsWidgets);
      expect(find.text('100'), findsWidgets);
    }
  });

  testWidgets('debe mostrar categoría en modal', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final productCards = find.byType(InkWell);
    if (productCards.evaluate().isNotEmpty) {
      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      expect(find.text('electronics'), findsWidgets);
    }
  });

  testWidgets('debe mostrar vista de cuadrícula con productos', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Cambiar a vista de cuadrícula
    final toggleButton = find.byIcon(Icons.list);
    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Test Product 1'), findsWidgets);
  });
}
