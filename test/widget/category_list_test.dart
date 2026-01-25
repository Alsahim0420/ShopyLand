import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/usecases/get_categories.dart';
import 'package:shopyland/presentation/widgets/category_list.dart';

import 'category_list_test.mocks.dart';

@GenerateMocks([GetCategories])
void main() {
  late MockGetCategories mockGetCategories;
  late List<CategoryEntity> testCategories;

  setUp(() {
    mockGetCategories = MockGetCategories();
    testCategories = [
      CategoryEntity(name: 'electronics'),
      CategoryEntity(name: 'jewelery'),
      CategoryEntity(name: "men's clothing"),
    ];
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: CategoryList(getCategories: mockGetCategories),
      ),
    );
  }

  testWidgets('debe mostrar un indicador de carga inicialmente',
      (WidgetTester tester) async {
    when(mockGetCategories()).thenAnswer((_) async => Right(testCategories));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Cargando categorías...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar la lista de categorías cuando se cargan exitosamente',
      (WidgetTester tester) async {
    when(mockGetCategories()).thenAnswer((_) async => Right(testCategories));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('ELECTRONICS'), findsOneWidget);
    expect(find.text('JEWELERY'), findsOneWidget);
    expect(find.text("MEN'S CLOTHING"), findsOneWidget);
  });

  testWidgets('debe mostrar un mensaje de error cuando falla la carga',
      (WidgetTester tester) async {
    const failure = ServerFailure('Error del servidor', 500);
    when(mockGetCategories()).thenAnswer((_) async => Left(failure));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Error: Error del servidor'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay categorías',
      (WidgetTester tester) async {
    when(mockGetCategories()).thenAnswer((_) async => const Right([]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('No hay categorías disponibles'), findsOneWidget);
  });

  testWidgets('debe mostrar iconos apropiados para cada categoría',
      (WidgetTester tester) async {
    when(mockGetCategories()).thenAnswer((_) async => Right(testCategories));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.devices), findsOneWidget); // electronics
    expect(find.byIcon(Icons.diamond), findsOneWidget); // jewelery
    expect(find.byIcon(Icons.male), findsOneWidget); // men's clothing
  });

  testWidgets('debe mostrar un SnackBar cuando se toca una categoría',
      (WidgetTester tester) async {
    when(mockGetCategories()).thenAnswer((_) async => Right(testCategories));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final categoryCard = find.byType(Card).first;
    await tester.tap(categoryCard);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Categoría: electronics'), findsOneWidget);
  });
}
