import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/data/datasources/remote_data_source.dart';
import 'package:shopyland/data/models/models.dart';
import 'package:shopyland/data/repositories/category_repository_impl.dart';
import 'package:shopyland/domain/entities/entities.dart';

import 'category_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource])
void main() {
  late CategoryRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository =
        CategoryRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tCategoryModels = [
    CategoryModel(name: 'electronics'),
    CategoryModel(name: 'jewelery'),
  ];

  final tCategoryEntities = [
    CategoryEntity(name: 'electronics'),
    CategoryEntity(name: 'jewelery'),
  ];

  group('getCategories', () {
    test('debe retornar una lista de categorías cuando la llamada es exitosa',
        () async {
      // Arrange
      when(mockRemoteDataSource.getCategories())
          .thenAnswer((_) async => tCategoryModels);

      // Act
      final result = await repository.getCategories();

      // Assert
      result.fold(
        (failure) => fail('Should not fail: ${failure.message}'),
        (entities) {
          expect(entities.length, tCategoryEntities.length);
          expect(entities.first.name, tCategoryEntities.first.name);
        },
      );
      verify(mockRemoteDataSource.getCategories()).called(1);
    });

    test('debe retornar ServerFailure cuando ocurre ServerException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getCategories())
          .thenThrow(ServerException('Error del servidor', 500));

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result, isA<Left<Failure, List<CategoryEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (_) => fail('Debería retornar un error'),
      );
    });

    test('debe retornar ConnectionFailure cuando ocurre ConnectionException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getCategories())
          .thenThrow(ConnectionException('Error de conexión'));

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result, isA<Left<Failure, List<CategoryEntity>>>());
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
      when(mockRemoteDataSource.getCategories())
          .thenThrow(ParsingException('Error al parsear'));

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result, isA<Left<Failure, List<CategoryEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ParsingFailure>());
        },
        (_) => fail('Debería retornar un error'),
      );
    });
  });
}
