import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  group('Integración del Carrito de Compras', () {
    late CartService cartService;
    late ProductEntity product1;
    late ProductEntity product2;

    setUp(() {
      cartService = CartService();
      cartService.clear();

      product1 = ProductEntity(
        id: 1,
        title: 'Product 1',
        price: 10.0,
        description: 'Description 1',
        category: 'category1',
        image: 'https://example.com/image1.jpg',
        rating: RatingEntity(rate: 4.0, count: 100),
      );

      product2 = ProductEntity(
        id: 2,
        title: 'Product 2',
        price: 20.0,
        description: 'Description 2',
        category: 'category2',
        image: 'https://example.com/image2.jpg',
        rating: RatingEntity(rate: 4.5, count: 50),
      );
    });

    test('debe agregar múltiples productos y calcular el total correctamente', () {
      cartService.addItem(CartItem(product: product1, quantity: 2));
      cartService.addItem(CartItem(product: product2, quantity: 1));

      expect(cartService.itemCount, 2);
      expect(cartService.totalPrice, 40.0); // (10 * 2) + (20 * 1)
    });

    test('debe actualizar la cantidad de un producto existente', () {
      cartService.addItem(CartItem(product: product1, quantity: 1));
      cartService.addItem(CartItem(product: product1, quantity: 2));

      expect(cartService.items.length, 1);
      expect(cartService.items.first.quantity, 3);
      expect(cartService.totalPrice, 30.0);
    });

    test('debe eliminar un producto y recalcular el total', () {
      cartService.addItem(CartItem(product: product1, quantity: 2));
      cartService.addItem(CartItem(product: product2, quantity: 1));

      expect(cartService.totalPrice, 40.0);

      cartService.removeItem(product1.id);

      expect(cartService.itemCount, 1);
      expect(cartService.totalPrice, 20.0);
    });

    test('debe limpiar el carrito completamente', () {
      cartService.addItem(CartItem(product: product1, quantity: 2));
      cartService.addItem(CartItem(product: product2, quantity: 1));

      expect(cartService.itemCount, 2);

      cartService.clear();

      expect(cartService.itemCount, 0);
      expect(cartService.totalPrice, 0.0);
      expect(cartService.items, isEmpty);
    });

    test('debe verificar correctamente si un producto está en el carrito', () {
      expect(cartService.isInCart(product1.id), false);

      cartService.addItem(CartItem(product: product1, quantity: 1));

      expect(cartService.isInCart(product1.id), true);
      expect(cartService.isInCart(product2.id), false);
    });

    test('debe obtener la cantidad correcta de un producto', () {
      cartService.addItem(CartItem(product: product1, quantity: 5));

      expect(cartService.getQuantity(product1.id), 5);
      expect(cartService.getQuantity(product2.id), 0);
    });
  });
}
