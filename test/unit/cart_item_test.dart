import 'package:conectify/conectify.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';

void main() {
  Product product(int id, double price) => Product(
    id: id,
    title: 'Product $id',
    price: price,
    description: 'Desc',
    category: 'cat',
    image: 'https://a.b/c.png',
    rating: const Rating(rate: 4.5, count: 10),
  );

  group('CartItem', () {
    test('totalPrice es price * quantity', () {
      final p = product(1, 10.0);
      final item = CartItem(product: p, quantity: 3);
      expect(item.totalPrice, 30.0);
    });

    test('quantity por defecto es 1', () {
      final item = CartItem(product: product(1, 5.0));
      expect(item.quantity, 1);
      expect(item.totalPrice, 5.0);
    });
  });
}
