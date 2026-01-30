import 'package:conectify/conectify.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';

void main() {
  late CartService cart;

  Product product(int id, double price) => Product(
    id: id,
    title: 'Product $id',
    price: price,
    description: 'Desc',
    category: 'cat',
    image: 'https://a.b/c.png',
    rating: const Rating(rate: 4.5, count: 10),
  );

  setUp(() {
    cart = CartService();
    cart.clear();
  });

  group('CartService', () {
    test('inicia vacío', () {
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('addItem incrementa itemCount y totalPrice', () {
      cart.addItem(CartItem(product: product(1, 10.0), quantity: 2));
      expect(cart.itemCount, 1);
      expect(cart.totalPrice, 20.0);
    });

    test('addItem mismo product incrementa quantity', () {
      cart.addItem(CartItem(product: product(1, 10.0), quantity: 1));
      cart.addItem(CartItem(product: product(1, 10.0), quantity: 2));
      expect(cart.itemCount, 1);
      expect(cart.getQuantity(1), 3);
      expect(cart.totalPrice, 30.0);
    });

    test('removeItem elimina por productId', () {
      cart.addItem(CartItem(product: product(1, 10.0)));
      cart.removeItem(1);
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('updateQuantity a 0 elimina el ítem', () {
      cart.addItem(CartItem(product: product(1, 10.0), quantity: 2));
      cart.updateQuantity(1, 0);
      expect(cart.itemCount, 0);
    });

    test('updateQuantity actualiza cantidad', () {
      cart.addItem(CartItem(product: product(1, 10.0), quantity: 1));
      cart.updateQuantity(1, 5);
      expect(cart.getQuantity(1), 5);
      expect(cart.totalPrice, 50.0);
    });

    test('clear vacía el carrito', () {
      cart.addItem(CartItem(product: product(1, 10.0)));
      cart.clear();
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('isInCart devuelve true si existe', () {
      cart.addItem(CartItem(product: product(1, 10.0)));
      expect(cart.isInCart(1), isTrue);
      expect(cart.isInCart(2), isFalse);
    });

    test('getQuantity devuelve 0 si no existe', () {
      expect(cart.getQuantity(99), 0);
    });
  });
}
