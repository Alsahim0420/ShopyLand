import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('CategoryEntity', () {
    test('debe crear un CategoryEntity correctamente', () {
      const category = CategoryEntity(name: 'electronics');

      expect(category.name, 'electronics');
    });

    test('debe comparar correctamente con ==', () {
      const category1 = CategoryEntity(name: 'electronics');
      const category2 = CategoryEntity(name: 'electronics');
      const category3 = CategoryEntity(name: 'jewelery');

      expect(category1 == category2, true);
      expect(category1 == category3, false);
    });

    test('debe tener hashCode correcto', () {
      const category1 = CategoryEntity(name: 'electronics');
      const category2 = CategoryEntity(name: 'electronics');

      expect(category1.hashCode, category2.hashCode);
    });

    test('debe verificar identical en ==', () {
      const category1 = CategoryEntity(name: 'electronics');

      expect(category1 == category1, true);
    });

    test('debe retornar false cuando se compara con tipo diferente', () {
      const category = CategoryEntity(name: 'electronics');
      expect(category == 'not a category', false);
      expect(category == 123, false);
    });
  });
}
