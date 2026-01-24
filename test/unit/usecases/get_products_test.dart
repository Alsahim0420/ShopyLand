import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/repositories/repositories.dart';
import 'package:shopyland/domain/usecases/get_products.dart';

import 'get_products_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProducts useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProducts(mockRepository);
  });

  final tProducts = [
    ProductEntity(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'electronics',
      image: 'https://example.com/image.jpg',
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

  test('debe obtener la lista de productos del repositorio', () async {
    // Arrange
    when(mockRepository.getProducts())
        .thenAnswer((_) async => Right(tProducts));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(tProducts));
    verify(mockRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('debe retornar un ServerFailure cuando el repositorio falla', () async {
    // Arrange
    const tFailure = ServerFailure('Error del servidor', 500);
    when(mockRepository.getProducts()).thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getProducts()).called(1);
  });

  test('debe retornar un ConnectionFailure cuando hay error de conexión',
      () async {
    // Arrange
    const tFailure = ConnectionFailure('Error de conexión');
    when(mockRepository.getProducts()).thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getProducts()).called(1);
  });

  test('debe retornar un ParsingFailure cuando hay error de parsing',
      () async {
    // Arrange
    const tFailure = ParsingFailure('Error al parsear datos');
    when(mockRepository.getProducts()).thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getProducts()).called(1);
  });
}
