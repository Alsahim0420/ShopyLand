import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/repositories/repositories.dart';
import 'package:shopyland/domain/usecases/get_users.dart';

import 'get_users_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUsers useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUsers(mockRepository);
  });

  final tUsers = [
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

  test('debe obtener la lista de usuarios del repositorio', () async {
    // Arrange
    when(mockRepository.getUsers()).thenAnswer((_) async => Right(tUsers));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(tUsers));
    verify(mockRepository.getUsers()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('debe retornar un ServerFailure cuando el repositorio falla', () async {
    // Arrange
    const tFailure = ServerFailure('Error del servidor', 500);
    when(mockRepository.getUsers()).thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getUsers()).called(1);
  });

  test('debe retornar un ConnectionFailure cuando hay error de conexión',
      () async {
    // Arrange
    const tFailure = ConnectionFailure('Error de conexión');
    when(mockRepository.getUsers()).thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(tFailure));
    verify(mockRepository.getUsers()).called(1);
  });
}
