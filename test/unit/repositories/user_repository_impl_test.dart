import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/data/datasources/remote_data_source.dart';
import 'package:shopyland/data/models/models.dart';
import 'package:shopyland/data/repositories/user_repository_impl.dart';
import 'package:shopyland/domain/entities/entities.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource])
void main() {
  late UserRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tUserModels = [
    UserModel(
      id: 1,
      email: 'test@example.com',
      username: 'testuser',
      name: NameModel(firstname: 'Test', lastname: 'User'),
      address: AddressModel(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationModel(lat: '0.0', long: '0.0'),
      ),
      phone: '1234567890',
    ),
  ];

  final tUserEntities = [
    UserEntity(
      id: 1,
      email: 'test@example.com',
      username: 'testuser',
      name: NameEntity(firstname: 'Test', lastname: 'User'),
      address: AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      ),
      phone: '1234567890',
    ),
  ];

  group('getUsers', () {
    test('debe retornar una lista de usuarios cuando la llamada es exitosa',
        () async {
      // Arrange
      when(mockRemoteDataSource.getUsers())
          .thenAnswer((_) async => tUserModels);

      // Act
      final result = await repository.getUsers();

      // Assert
      result.fold(
        (failure) => fail('Should not fail: ${failure.message}'),
        (entities) {
          expect(entities.length, tUserEntities.length);
          expect(entities.first.id, tUserEntities.first.id);
          expect(entities.first.email, tUserEntities.first.email);
        },
      );
      verify(mockRemoteDataSource.getUsers()).called(1);
    });

    test('debe retornar ServerFailure cuando ocurre ServerException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getUsers())
          .thenThrow(ServerException('Error del servidor', 500));

      // Act
      final result = await repository.getUsers();

      // Assert
      expect(result, isA<Left<Failure, List<UserEntity>>>());
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
      when(mockRemoteDataSource.getUsers())
          .thenThrow(ConnectionException('Error de conexión'));

      // Act
      final result = await repository.getUsers();

      // Assert
      expect(result, isA<Left<Failure, List<UserEntity>>>());
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
      when(mockRemoteDataSource.getUsers())
          .thenThrow(ParsingException('Error al parsear'));

      // Act
      final result = await repository.getUsers();

      // Assert
      expect(result, isA<Left<Failure, List<UserEntity>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ParsingFailure>());
        },
        (_) => fail('Debería retornar un error'),
      );
    });
  });
}
