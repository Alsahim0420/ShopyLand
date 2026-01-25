import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/repositories/repositories.dart';
import 'package:shopyland/domain/usecases/get_categories.dart';

import 'get_categories_test.mocks.dart';

@GenerateMocks([CategoryRepository])
void main() {
  late GetCategories useCase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    useCase = GetCategories(mockRepository);
  });

  final tCategories = [
    CategoryEntity(name: 'electronics'),
    CategoryEntity(name: 'jewelery'),
    CategoryEntity(name: "men's clothing"),
    CategoryEntity(name: "women's clothing"),
  ];

  test('debe obtener la lista de categorías del repositorio', () async {
    // Arrange
    when(mockRepository.getCategories())
        .thenAnswer((_) async => Right(tCategories));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(tCategories));
    verify(mockRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('debe retornar un ServerFailure cuando el repositorio falla', () async {
    // Arrange
    const tFailure = ServerFailure('Error del servidor', 500);
    when(mockRepository.getCategories())
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getCategories()).called(1);
  });

  test('debe retornar un ConnectionFailure cuando hay error de conexión',
      () async {
    // Arrange
    const tFailure = ConnectionFailure('Error de conexión');
    when(mockRepository.getCategories())
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getCategories()).called(1);
  });
}
