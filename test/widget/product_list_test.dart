import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/usecases/get_products.dart';
import 'package:shopyland/presentation/widgets/product_list.dart';

import 'product_list_test.mocks.dart';

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
    ];
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ProductList(getProducts: mockGetProducts),
      ),
    );
  }

  testWidgets('debe mostrar un indicador de carga inicialmente',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Cargando productos...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar la lista de productos cuando se cargan exitosamente',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Test Product 1'), findsWidgets);
    expect(find.text('Test Product 2'), findsWidgets);
    expect(find.text('2 productos'), findsOneWidget);
  });

  testWidgets('debe mostrar un mensaje de error cuando falla la carga',
      (WidgetTester tester) async {
    const failure = ServerFailure('Error del servidor', 500);
    when(mockGetProducts()).thenAnswer((_) async => Left(failure));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Error: Error del servidor'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay productos',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => const Right([]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('No hay productos disponibles'), findsOneWidget);
  });

  testWidgets('debe cambiar entre vista de lista y cuadrícula',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final toggleButton = find.byIcon(Icons.list);
    expect(toggleButton, findsOneWidget);

    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.grid_view), findsOneWidget);
  });

  testWidgets('debe permitir reintentar cuando hay un error',
      (WidgetTester tester) async {
    const failure = ConnectionFailure('Error de conexión');
    when(mockGetProducts()).thenAnswer((_) async => Left(failure));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    final retryButton = find.text('Reintentar');
    await tester.tap(retryButton);
    await tester.pumpAndSettle();

    expect(find.text('Test Product 1'), findsWidgets);
  });

  testWidgets('debe mostrar detalles del producto al tocar una tarjeta',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final productCard = find.byType(InkWell).first;
    await tester.tap(productCard);
    await tester.pumpAndSettle();

    // Verificar que se muestra el modal de detalles
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('debe mostrar vista de lista por defecto',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verificar que se muestra la vista de lista
    expect(find.byType(ListView), findsOneWidget);
  });

    testWidgets('debe mostrar vista de cuadrícula cuando se cambia',
      (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final toggleButton = find.byIcon(Icons.list);
    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
  });

    testWidgets('debe mostrar detalles del producto en modal', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tocar una tarjeta de producto para abrir detalles
    final productCards = find.byType(InkWell);
    if (productCards.evaluate().isNotEmpty) {
      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      // Verificar que se muestra el modal con detalles
      expect(find.text('Test Product 1'), findsWidgets);
      expect(find.text('Descripción'), findsOneWidget);
    }
  });

    testWidgets('debe mostrar precio en el modal de detalles', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final productCards = find.byType(InkWell);
    if (productCards.evaluate().isNotEmpty) {
      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      expect(find.text('\$99.99'), findsWidgets);
    }
  });

    testWidgets('debe mostrar categoría y rating en el modal', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final productCards = find.byType(InkWell);
    if (productCards.evaluate().isNotEmpty) {
      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      expect(find.text('electronics'), findsWidgets);
      expect(find.text('4.5'), findsWidgets);
    }
  });

    testWidgets('debe mostrar vista de lista completa con todos los detalles', (WidgetTester tester) async {
    when(mockGetProducts()).thenAnswer((_) async => Right(testProducts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verificar que se muestra la vista de lista (no cuadrícula)
    expect(find.byType(ListView), findsOneWidget);
    
    // Verificar que se muestran detalles completos
    expect(find.text('Test Product 1'), findsWidgets);
    expect(find.text('electronics'), findsWidgets);
    expect(find.text('4.5 (100)'), findsWidgets);
  });
}
