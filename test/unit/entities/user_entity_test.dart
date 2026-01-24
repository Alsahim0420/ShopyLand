import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('UserEntity', () {
    test('debe crear un UserEntity correctamente', () {
      const user = UserEntity(
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
      );

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.username, 'testuser');
      expect(user.name.firstname, 'Test');
      expect(user.name.lastname, 'User');
      expect(user.address.city, 'Test City');
      expect(user.phone, '1234567890');
    });

    test('debe comparar correctamente con ==', () {
      const user1 = UserEntity(
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
      );

      const user2 = UserEntity(
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
      );

      const user3 = UserEntity(
        id: 2,
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
      );

      expect(user1 == user2, true);
      expect(user1 == user3, false);
      // Línea 21: if (identical(this, other)) return true;
      expect(user1 == user1, true); // identical check
    });

    test('debe tener hashCode correcto - línea 33', () {
      const user1 = UserEntity(
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
      );

      const user2 = UserEntity(
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
      );

      // Línea 33: return Object.hash(id, email, username, name, address, phone);
      expect(user1.hashCode, user2.hashCode);
    });

    test('debe retornar false cuando se compara con tipo diferente', () {
      const user = UserEntity(
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
      );

      expect(user == 'not a user', false);
      expect(user == 123, false);
      expect(user == null, false);
    });

    test('debe comparar todos los campos correctamente', () {
      const baseUser = UserEntity(
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
      );

      // Diferente id - línea 23: other.id == id
      const userDifferentId = UserEntity(
        id: 2,
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
      );

      // Diferente email - línea 24: other.email == email
      const userDifferentEmail = UserEntity(
        id: 1,
        email: 'different@example.com',
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
      );

      // Diferente username - línea 25: other.username == username
      const userDifferentUsername = UserEntity(
        id: 1,
        email: 'test@example.com',
        username: 'different',
        name: NameEntity(firstname: 'Test', lastname: 'User'),
        address: AddressEntity(
          city: 'Test City',
          street: 'Test Street',
          number: 123,
          zipcode: '12345',
          geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
        ),
        phone: '1234567890',
      );

      // Diferente name - línea 26: other.name == name
      const userDifferentName = UserEntity(
        id: 1,
        email: 'test@example.com',
        username: 'testuser',
        name: NameEntity(firstname: 'Different', lastname: 'User'),
        address: AddressEntity(
          city: 'Test City',
          street: 'Test Street',
          number: 123,
          zipcode: '12345',
          geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
        ),
        phone: '1234567890',
      );

      // Diferente address - línea 27: other.address == address
      const userDifferentAddress = UserEntity(
        id: 1,
        email: 'test@example.com',
        username: 'testuser',
        name: NameEntity(firstname: 'Test', lastname: 'User'),
        address: AddressEntity(
          city: 'Different City',
          street: 'Test Street',
          number: 123,
          zipcode: '12345',
          geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
        ),
        phone: '1234567890',
      );

      // Diferente phone - línea 28: other.phone == phone
      const userDifferentPhone = UserEntity(
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
        phone: '9999999999',
      );

      expect(baseUser == userDifferentId, false);
      expect(baseUser == userDifferentEmail, false);
      expect(baseUser == userDifferentUsername, false);
      expect(baseUser == userDifferentName, false);
      expect(baseUser == userDifferentAddress, false);
      expect(baseUser == userDifferentPhone, false);
    });

    test('debe ejecutar todas las comparaciones en el operador == - líneas 22-28', () {
      const user1 = UserEntity(
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
      );

      const user2 = UserEntity(
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
      );

      // Ejecuta todas las líneas 22-28 del operador ==
      expect(user1 == user2, true);
    });
  });

  group('NameEntity', () {
    test('debe crear un NameEntity correctamente', () {
      const name = NameEntity(firstname: 'John', lastname: 'Doe');
      expect(name.firstname, 'John');
      expect(name.lastname, 'Doe');
    });

    test('debe retornar fullName correctamente', () {
      const name = NameEntity(firstname: 'John', lastname: 'Doe');
      expect(name.fullName, 'John Doe');
    });

    test('debe verificar identical en == - línea 48', () {
      const name1 = NameEntity(firstname: 'John', lastname: 'Doe');
      
      // Línea 48: if (identical(this, other)) return true;
      expect(name1 == name1, true);
    });

    test('debe comparar correctamente con == - líneas 47-51', () {
      const name1 = NameEntity(firstname: 'John', lastname: 'Doe');
      const name2 = NameEntity(firstname: 'John', lastname: 'Doe');
      const name3 = NameEntity(firstname: 'Jane', lastname: 'Doe');
      const name4 = NameEntity(firstname: 'John', lastname: 'Smith');

      // Líneas 49-50: other.firstname == firstname && other.lastname == lastname
      expect(name1 == name2, true);
      expect(name1 == name3, false); // Diferente firstname
      expect(name1 == name4, false); // Diferente lastname
    });

    test('debe retornar false cuando se compara con tipo diferente', () {
      const name = NameEntity(firstname: 'John', lastname: 'Doe');
      expect(name == 'not a name', false);
      expect(name == 123, false);
    });

    test('debe tener hashCode correcto - línea 55', () {
      const name1 = NameEntity(firstname: 'John', lastname: 'Doe');
      const name2 = NameEntity(firstname: 'John', lastname: 'Doe');
      
      // Línea 55: int get hashCode => Object.hash(firstname, lastname);
      expect(name1.hashCode, name2.hashCode);
    });
  });

  group('AddressEntity', () {
    test('debe crear un AddressEntity correctamente', () {
      const address = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      expect(address.city, 'Test City');
      expect(address.street, 'Test Street');
      expect(address.number, 123);
      expect(address.zipcode, '12345');
    });

    test('debe verificar identical en == - línea 76', () {
      const address1 = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Línea 76: if (identical(this, other)) return true;
      expect(address1 == address1, true);
    });

    test('debe comparar correctamente con == - líneas 75-82', () {
      const address1 = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      const address2 = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      const address3 = AddressEntity(
        city: 'Other City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Ejecuta líneas 77-82: comparación de todos los campos
      expect(address1 == address2, true);
      expect(address1 == address3, false);
    });

    test('debe tener hashCode correcto - línea 87', () {
      const address1 = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      const address2 = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Línea 87: return Object.hash(city, street, number, zipcode, geolocation);
      expect(address1.hashCode, address2.hashCode);
    });

    test('debe retornar false cuando se compara con tipo diferente', () {
      const address = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      expect(address == 'not an address', false);
      expect(address == 123, false);
    });

    test('debe comparar todos los campos correctamente', () {
      const baseAddress = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Diferente city - línea 78: other.city == city
      const addressDifferentCity = AddressEntity(
        city: 'Different City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Diferente street - línea 79: other.street == street
      const addressDifferentStreet = AddressEntity(
        city: 'Test City',
        street: 'Different Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Diferente number - línea 80: other.number == number
      const addressDifferentNumber = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 999,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Diferente zipcode - línea 81: other.zipcode == zipcode
      const addressDifferentZipcode = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '99999',
        geolocation: GeolocationEntity(lat: '0.0', long: '0.0'),
      );

      // Diferente geolocation - línea 82: other.geolocation == geolocation
      const addressDifferentGeolocation = AddressEntity(
        city: 'Test City',
        street: 'Test Street',
        number: 123,
        zipcode: '12345',
        geolocation: GeolocationEntity(lat: '1.0', long: '1.0'),
      );

      expect(baseAddress == addressDifferentCity, false);
      expect(baseAddress == addressDifferentStreet, false);
      expect(baseAddress == addressDifferentNumber, false);
      expect(baseAddress == addressDifferentZipcode, false);
      expect(baseAddress == addressDifferentGeolocation, false);
    });
  });

  group('GeolocationEntity', () {
    test('debe crear un GeolocationEntity correctamente', () {
      const geolocation = GeolocationEntity(lat: '0.0', long: '0.0');

      expect(geolocation.lat, '0.0');
      expect(geolocation.long, '0.0');
    });

    test('debe verificar identical en == - línea 100', () {
      const geo1 = GeolocationEntity(lat: '0.0', long: '0.0');
      
      // Línea 100: if (identical(this, other)) return true;
      expect(geo1 == geo1, true);
    });

    test('debe comparar correctamente con == - líneas 99-101', () {
      const geo1 = GeolocationEntity(lat: '0.0', long: '0.0');
      const geo2 = GeolocationEntity(lat: '0.0', long: '0.0');
      const geo3 = GeolocationEntity(lat: '1.0', long: '0.0');
      const geo4 = GeolocationEntity(lat: '0.0', long: '1.0');

      // Línea 101: other.lat == lat && other.long == long
      expect(geo1 == geo2, true);
      expect(geo1 == geo3, false); // Diferente lat
      expect(geo1 == geo4, false); // Diferente long
    });

    test('debe tener hashCode correcto - línea 105', () {
      const geo1 = GeolocationEntity(lat: '0.0', long: '0.0');
      const geo2 = GeolocationEntity(lat: '0.0', long: '0.0');

      // Línea 105: int get hashCode => Object.hash(lat, long);
      expect(geo1.hashCode, geo2.hashCode);
    });

    test('debe retornar false cuando se compara con tipo diferente', () {
      const geo = GeolocationEntity(lat: '0.0', long: '0.0');
      expect(geo == 'not a geolocation', false);
      expect(geo == 123, false);
    });
  });
}
