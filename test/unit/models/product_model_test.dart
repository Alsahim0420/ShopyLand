import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/data/models/models.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('ProductModel', () {
    test('debe crear un ProductModel desde JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 99.99,
        'description': 'Test Description',
        'category': 'electronics',
        'image': 'https://example.com/image.jpg',
        'rating': {
          'rate': 4.5,
          'count': 100,
        },
      };

      final model = ProductModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, 'Test Product');
      expect(model.price, 99.99);
      expect(model.description, 'Test Description');
      expect(model.category, 'electronics');
      expect(model.image, 'https://example.com/image.jpg');
      expect(model.rating.rate, 4.5);
      expect(model.rating.count, 100);
    });

    test('debe convertir ProductModel a entidad', () {
      final model = ProductModel(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingModel(rate: 4.5, count: 100),
      );

      final entity = model.toEntity();

      expect(entity, isA<ProductEntity>());
      expect(entity.id, 1);
      expect(entity.title, 'Test Product');
      expect(entity.price, 99.99);
      expect(entity.description, 'Test Description');
      expect(entity.category, 'electronics');
      expect(entity.image, 'https://example.com/image.jpg');
      expect(entity.rating.rate, 4.5);
      expect(entity.rating.count, 100);
    });

    test('debe convertir ProductModel a JSON', () {
      final model = ProductModel(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingModel(rate: 4.5, count: 100),
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Product');
      expect(json['price'], 99.99);
      expect(json['description'], 'Test Description');
      expect(json['category'], 'electronics');
      expect(json['image'], 'https://example.com/image.jpg');
      expect(json['rating'], isA<Map<String, dynamic>>());
      expect(json['rating']['rate'], 4.5);
      expect(json['rating']['count'], 100);
    });
  });

  group('RatingModel', () {
    test('debe crear un RatingModel desde JSON', () {
      final json = {
        'rate': 4.5,
        'count': 100,
      };

      final model = RatingModel.fromJson(json);

      expect(model.rate, 4.5);
      expect(model.count, 100);
    });

    test('debe convertir RatingModel a entidad', () {
      final model = RatingModel(rate: 4.5, count: 100);

      final entity = model.toEntity();

      expect(entity, isA<RatingEntity>());
      expect(entity.rate, 4.5);
      expect(entity.count, 100);
    });

    test('debe convertir RatingModel a JSON', () {
      final model = RatingModel(rate: 4.5, count: 100);

      final json = model.toJson();

      expect(json['rate'], 4.5);
      expect(json['count'], 100);
    });
  });
}
