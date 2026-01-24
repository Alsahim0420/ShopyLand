import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('CartItem', () {
    late ProductEntity testProduct;

    setUp(() {
      testProduct = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );
    });

    test('debe crear un CartItem con cantidad por defecto de 1', () {
      final item = CartItem(product: testProduct);

      expect(item.product, testProduct);
      expect(item.quantity, 1);
    });

    test('debe crear un CartItem con cantidad personalizada', () {
      final item = CartItem(product: testProduct, quantity: 5);

      expect(item.product, testProduct);
      expect(item.quantity, 5);
    });

    test('debe calcular el precio total correctamente', () {
      final item = CartItem(product: testProduct, quantity: 3);

      expect(item.totalPrice, testProduct.price * 3);
    });

    test('debe crear una copia con copyWith', () {
      final item = CartItem(product: testProduct, quantity: 2);
      final newProduct = ProductEntity(
        id: 2,
        title: 'New Product',
        price: 149.99,
        description: 'New Description',
        category: 'clothing',
        image: 'https://example.com/new.jpg',
        rating: RatingEntity(rate: 4.0, count: 50),
      );

      final copiedItem = item.copyWith(product: newProduct, quantity: 5);

      expect(copiedItem.product, newProduct);
      expect(copiedItem.quantity, 5);
      expect(item.product, testProduct); // Original no debe cambiar
      expect(item.quantity, 2);
    });

    test('debe crear una copia parcial con copyWith', () {
      final item = CartItem(product: testProduct, quantity: 2);

      final copiedItem = item.copyWith(quantity: 5);

      expect(copiedItem.product, testProduct);
      expect(copiedItem.quantity, 5);
    });
  });
}
