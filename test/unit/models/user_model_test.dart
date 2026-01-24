import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/data/models/models.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('UserModel', () {
    test('debe crear un UserModel desde JSON', () {
      final json = {
        'id': 1,
        'email': 'test@example.com',
        'username': 'testuser',
        'name': {
          'firstname': 'Test',
          'lastname': 'User',
        },
        'address': {
          'city': 'Test City',
          'street': 'Test Street',
          'number': 123,
          'zipcode': '12345',
          'geolocation': {
            'lat': '0.0',
            'long': '0.0',
          },
        },
        'phone': '1234567890',
      };

      final model = UserModel.fromJson(json);

      expect(model.id, 1);
      expect(model.email, 'test@example.com');
      expect(model.username, 'testuser');
      expect(model.name.firstname, 'Test');
      expect(model.name.lastname, 'User');
      expect(model.address.city, 'Test City');
      expect(model.address.street, 'Test Street');
      expect(model.address.number, 123);
      expect(model.address.zipcode, '12345');
      expect(model.address.geolocation.lat, '0.0');
      expect(model.address.geolocation.long, '0.0');
      expect(model.phone, '1234567890');
    });

    test('debe convertir UserModel a entidad', () {
      final model = UserModel(
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
      );

      final entity = model.toEntity();

      expect(entity, isA<UserEntity>());
      expect(entity.id, 1);
      expect(entity.email, 'test@example.com');
      expect(entity.username, 'testuser');
      expect(entity.name.firstname, 'Test');
      expect(entity.name.lastname, 'User');
      expect(entity.address.city, 'Test City');
      expect(entity.phone, '1234567890');
    });

    test('debe convertir UserModel a JSON', () {
      final model = UserModel(
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
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['email'], 'test@example.com');
      expect(json['username'], 'testuser');
      expect(json['name'], isA<Map<String, dynamic>>());
      expect(json['address'], isA<Map<String, dynamic>>());
      expect(json['phone'], '1234567890');
    });
  });

  group('NameModel', () {
    test('debe crear un NameModel desde JSON', () {
      final json = {
        'firstname': 'Test',
        'lastname': 'User',
      };

      final model = NameModel.fromJson(json);

      expect(model.firstname, 'Test');
      expect(model.lastname, 'User');
    });

    test('debe convertir NameModel a entidad', () {
      final model = NameModel(firstname: 'Test', lastname: 'User');

      final entity = model.toEntity();

      expect(entity, isA<NameEntity>());
      expect(entity.firstname, 'Test');
      expect(entity.lastname, 'User');
    });

    test('debe convertir NameModel a JSON', () {
      final model = NameModel(firstname: 'Test', lastname: 'User');

      final json = model.toJson();

      expect(json['firstname'], 'Test');
      expect(json['lastname'], 'User');
    });
  });

  group('AddressModel', () {
    test('debe crear un AddressModel desde JSON', () {
      final json = {
        'city': 'Test City',
        'street': 'Test Street',
        'number': 123,
        'zipcode': '12345',
        'geolocation': {
          'lat': '0.0',
          'long': '0.0',
        },
      };

      final model = AddressModel.fromJson(json);

      expect(model.city, 'Test City');
      expect(model.street, 'Test Street');
      expect(model.number, 123);
      expect(model.zipcode, '12345');
      expect(model.geolocation.lat, '0.0');
      expect(model.geolocation.long, '0.0');
    });

    test('debe convertir AddressModel a entidad', () {
      final model = AddressModel(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationModel(lat: '0.0', long: '0.0'),
      );

      final entity = model.toEntity();

      expect(entity, isA<AddressEntity>());
      expect(entity.city, 'Test City');
      expect(entity.street, 'Test Street');
      expect(entity.number, 123);
      expect(entity.zipcode, '12345');
    });

    test('debe convertir AddressModel a JSON', () {
      final model = AddressModel(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationModel(lat: '0.0', long: '0.0'),
      );

      final json = model.toJson();

      expect(json['city'], 'Test City');
      expect(json['street'], 'Test Street');
      expect(json['number'], 123);
      expect(json['zipcode'], '12345');
      expect(json['geolocation'], isA<Map<String, dynamic>>());
    });
  });

  group('GeolocationModel', () {
    test('debe crear un GeolocationModel desde JSON', () {
      final json = {
        'lat': '0.0',
        'long': '0.0',
      };

      final model = GeolocationModel.fromJson(json);

      expect(model.lat, '0.0');
      expect(model.long, '0.0');
    });

    test('debe convertir GeolocationModel a entidad', () {
      final model = GeolocationModel(lat: '0.0', long: '0.0');

      final entity = model.toEntity();

      expect(entity, isA<GeolocationEntity>());
      expect(entity.lat, '0.0');
      expect(entity.long, '0.0');
    });

    test('debe convertir GeolocationModel a JSON', () {
      final model = GeolocationModel(lat: '0.0', long: '0.0');

      final json = model.toJson();

      expect(json['lat'], '0.0');
      expect(json['long'], '0.0');
    });
  });
}
