import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/data/models/models.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('CategoryModel', () {
    test('debe crear un CategoryModel desde JSON (string)', () {
      final json = 'electronics';

      final model = CategoryModel.fromJson(json);

      expect(model.name, 'electronics');
    });

    test('debe crear un CategoryModel desde JSON (Map)', () {
      final json = {'name': 'electronics'};

      final model = CategoryModel.fromJson(json);

      expect(model.name, 'electronics');
    });

    test('debe lanzar FormatException con formato inválido', () {
      final json = 123;

      expect(() => CategoryModel.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('debe convertir CategoryModel a entidad', () {
      final model = CategoryModel(name: 'electronics');

      final entity = model.toEntity();

      expect(entity, isA<CategoryEntity>());
      expect(entity.name, 'electronics');
    });

    test('debe convertir CategoryModel a JSON', () {
      final model = CategoryModel(name: 'electronics');

      final json = model.toJson();

      expect(json, 'electronics');
    });
  });
}
