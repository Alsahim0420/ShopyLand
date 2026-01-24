import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopyland/core/errors/errors.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/domain/usecases/get_users.dart';
import 'package:shopyland/presentation/widgets/user_list.dart';

import 'user_list_test.mocks.dart';

@GenerateMocks([GetUsers])
void main() {
  late MockGetUsers mockGetUsers;
  late List<UserEntity> testUsers;

  setUp(() {
    mockGetUsers = MockGetUsers();
    testUsers = [
      UserEntity(
        id: 1,
        email: 'test1@example.com',
        username: 'testuser1',
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
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: UserList(getUsers: mockGetUsers),
      ),
    );
  }

  testWidgets('debe mostrar un indicador de carga inicialmente',
      (WidgetTester tester) async {
    when(mockGetUsers()).thenAnswer((_) async => Right(testUsers));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Cargando usuarios...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('debe mostrar la lista de usuarios cuando se cargan exitosamente',
      (WidgetTester tester) async {
    when(mockGetUsers()).thenAnswer((_) async => Right(testUsers));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test1@example.com'), findsOneWidget);
  });

  testWidgets('debe mostrar un mensaje de error cuando falla la carga',
      (WidgetTester tester) async {
    const failure = ServerFailure('Error del servidor', 500);
    when(mockGetUsers()).thenAnswer((_) async => Left(failure));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Error: Error del servidor'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('debe mostrar mensaje cuando no hay usuarios',
      (WidgetTester tester) async {
    when(mockGetUsers()).thenAnswer((_) async => const Right([]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('No hay usuarios disponibles'), findsOneWidget);
  });
}
