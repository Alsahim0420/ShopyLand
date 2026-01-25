import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
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

    test('debe comparar correctamente con ==', () {
      const name1 = NameEntity(firstname: 'John', lastname: 'Doe');
      const name2 = NameEntity(firstname: 'John', lastname: 'Doe');
      const name3 = NameEntity(firstname: 'Jane', lastname: 'Doe');

      expect(name1 == name2, true);
      expect(name1 == name3, false);
    });

    test('debe tener hashCode correcto', () {
      const name1 = NameEntity(firstname: 'John', lastname: 'Doe');
      const name2 = NameEntity(firstname: 'John', lastname: 'Doe');

      expect(name1.hashCode, name2.hashCode);
    });
  });
}
