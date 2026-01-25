import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('ProductEntity', () {
    test('debe crear un ProductEntity correctamente', () {
      const product = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.description, 'Test Description');
      expect(product.category, 'electronics');
      expect(product.image, 'https://example.com/image.jpg');
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 100);
    });

    test('debe comparar correctamente con ==', () {
      const product1 = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      const product2 = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      const product3 = ProductEntity(
        id: 2,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      expect(product1 == product2, true);
      expect(product1 == product3, false);
    });

    test('debe tener hashCode correcto - línea 37', () {
      const product1 = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      const product2 = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Línea 37: return Object.hash(id, title, price, description, category, image, rating);
      expect(product1.hashCode, product2.hashCode);
    });

    test('debe verificar identical en == - línea 24', () {
      const product1 = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Línea 24: if (identical(this, other)) return true;
      expect(product1 == product1, true);
    });

    test('debe retornar false cuando se compara con tipo diferente', () {
      const product = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      expect(product == 'not a product', false);
      expect(product == 123, false);
    });

    test('debe comparar todos los campos correctamente', () {
      const baseProduct = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Diferente title - línea 27: other.title == title
      const productDifferentTitle = ProductEntity(
        id: 1,
        title: 'Different Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Diferente price - línea 28: other.price == price
      const productDifferentPrice = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 199.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Diferente description - línea 29: other.description == description
      const productDifferentDescription = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Different Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Diferente category - línea 30: other.category == category
      const productDifferentCategory = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'clothing',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Diferente image - línea 31: other.image == image
      const productDifferentImage = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/different.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Diferente rating - línea 32: other.rating == rating
      const productDifferentRating = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 3.0, count: 50),
      );

      expect(baseProduct == productDifferentTitle, false);
      expect(baseProduct == productDifferentPrice, false);
      expect(baseProduct == productDifferentDescription, false);
      expect(baseProduct == productDifferentCategory, false);
      expect(baseProduct == productDifferentImage, false);
      expect(baseProduct == productDifferentRating, false);
    });

    test('debe ejecutar todas las comparaciones en el operador ==', () {
      const product1 = ProductEntity(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img.jpg',
        rating: RatingEntity(rate: 4.0, count: 10),
      );

      const product2 = ProductEntity(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img.jpg',
        rating: RatingEntity(rate: 4.0, count: 10),
      );

      // Ejecuta todas las líneas 25-32 del operador ==
      expect(product1 == product2, true);
    });
  });

  group('RatingEntity', () {
    test('debe crear un RatingEntity correctamente - líneas 42-46', () {
      const rating = RatingEntity(rate: 4.5, count: 100);

      // Líneas 43-44: final double rate; final int count;
      expect(rating.rate, 4.5);
      expect(rating.count, 100);
    });

    test('debe verificar identical en == - línea 50', () {
      const rating1 = RatingEntity(rate: 4.5, count: 100);
      
      // Línea 50: if (identical(this, other)) return true;
      expect(rating1 == rating1, true);
    });

    test('debe comparar correctamente con == - líneas 49-52', () {
      const rating1 = RatingEntity(rate: 4.5, count: 100);
      const rating2 = RatingEntity(rate: 4.5, count: 100);
      const rating3 = RatingEntity(rate: 4.0, count: 100);
      const rating4 = RatingEntity(rate: 4.5, count: 50);

      // Línea 51: other.rate == rate && other.count == count
      expect(rating1 == rating2, true);
      expect(rating1 == rating3, false); // Diferente rate
      expect(rating1 == rating4, false); // Diferente count
    });

    test('debe tener hashCode correcto - línea 55', () {
      const rating1 = RatingEntity(rate: 4.5, count: 100);
      const rating2 = RatingEntity(rate: 4.5, count: 100);

      // Línea 55: int get hashCode => Object.hash(rate, count);
      expect(rating1.hashCode, rating2.hashCode);
    });

    test('debe retornar false cuando se compara con tipo diferente - línea 51', () {
      const rating = RatingEntity(rate: 4.5, count: 100);
      
      // Línea 51: other is RatingEntity && ...
      expect(rating == 'not a rating', false);
      expect(rating == 123, false);
      expect(rating == null, false);
    });
  });
}
