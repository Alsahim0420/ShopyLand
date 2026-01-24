import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/data/datasources/remote_data_source.dart';
import 'package:shopyland/data/models/models.dart';
import 'package:shopyland/data/repositories/product_repository_impl.dart';
import 'package:shopyland/domain/entities/entities.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource])
void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ProductRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tProductModels = [
    ProductModel(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'electronics',
      image: 'https://example.com/image.jpg',
      rating: RatingModel(rate: 4.5, count: 100),
    ),
  ];

  final tProductEntities = [
    ProductEntity(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'electronics',
      image: 'https://example.com/image.jpg',
      rating: RatingEntity(rate: 4.5, count: 100),
    ),
  ];

  group('getProducts', () {
    test('debe retornar una lista de productos cuando la llamada es exitosa',
        () async {
      // Arrange
      when(mockRemoteDataSource.getProducts())
          .thenAnswer((_) async => tProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      result.fold(
        (failure) => fail('Should not fail: ${failure.message}'),
        (entities) {
          expect(entities.length, tProductEntities.length);
          expect(entities.first.id, tProductEntities.first.id);
          expect(entities.first.title, tProductEntities.first.title);
        },
      );
      verify(mockRemoteDataSource.getProducts()).called(1);
    });

    test('debe retornar ServerFailure cuando ocurre ServerException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getProducts())
          .thenThrow(ServerException('Error del servidor', 500));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isA<Left<Failure, List<ProductEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).statusCode, 500);
        },
        (_) => fail('Debería retornar un error'),
      );
    });

    test('debe retornar ConnectionFailure cuando ocurre ConnectionException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getProducts())
          .thenThrow(ConnectionException('Error de conexión'));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isA<Left<Failure, List<ProductEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
        },
        (_) => fail('Debería retornar un error'),
      );
    });

    test('debe retornar ParsingFailure cuando ocurre ParsingException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getProducts())
          .thenThrow(ParsingException('Error al parsear'));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isA<Left<Failure, List<ProductEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ParsingFailure>());
        },
        (_) => fail('Debería retornar un error'),
      );
    });

    test('debe retornar ConnectionFailure cuando ocurre una excepción genérica',
        () async {
      // Arrange
      when(mockRemoteDataSource.getProducts())
          .thenThrow(Exception('Error inesperado'));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isA<Left<Failure, List<ProductEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
        },
        (_) => fail('Debería retornar un error'),
      );
    });
  });
}
