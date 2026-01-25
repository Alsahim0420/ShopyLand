import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/entities.dart';

void main() {
  late CartService cartService;
  late ProductEntity testProduct;
  late ProductEntity testProduct2;

  setUp(() {
    cartService = CartService();
    cartService.clear();
    testProduct = ProductEntity(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'electronics',
      image: 'https://example.com/image.jpg',
      rating: RatingEntity(rate: 4.5, count: 100),
    );
    testProduct2 = ProductEntity(
      id: 2,
      title: 'Test Product 2',
      price: 149.99,
      description: 'Test Description 2',
      category: 'clothing',
      image: 'https://example.com/image2.jpg',
      rating: RatingEntity(rate: 4.0, count: 50),
    );
  });

  group('CartService', () {
    test('debe inicializar con carrito vacío', () {
      expect(cartService.items, isEmpty);
      expect(cartService.itemCount, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('debe agregar un item al carrito', () {
      final item = CartItem(product: testProduct, quantity: 1);
      cartService.addItem(item);

      expect(cartService.items.length, 1);
      expect(cartService.itemCount, 1);
      expect(cartService.items.first.product.id, testProduct.id);
    });

    test('debe incrementar la cantidad cuando se agrega el mismo producto',
        () {
      final item1 = CartItem(product: testProduct, quantity: 1);
      final item2 = CartItem(product: testProduct, quantity: 2);

      cartService.addItem(item1);
      cartService.addItem(item2);

      expect(cartService.items.length, 1);
      expect(cartService.items.first.quantity, 3);
    });

    test('debe calcular el precio total correctamente', () {
      final item1 = CartItem(product: testProduct, quantity: 2);
      final item2 = CartItem(product: testProduct2, quantity: 1);

      cartService.addItem(item1);
      cartService.addItem(item2);

      final expectedTotal = (testProduct.price * 2) + testProduct2.price;
      expect(cartService.totalPrice, expectedTotal);
    });

    test('debe eliminar un item del carrito', () {
      final item = CartItem(product: testProduct, quantity: 1);
      cartService.addItem(item);
      expect(cartService.items.length, 1);

      cartService.removeItem(testProduct.id);
      expect(cartService.items, isEmpty);
    });

    test('debe actualizar la cantidad de un item', () {
      final item = CartItem(product: testProduct, quantity: 1);
      cartService.addItem(item);

      cartService.updateQuantity(testProduct.id, 5);
      expect(cartService.items.first.quantity, 5);
    });

    test('debe eliminar el item cuando la cantidad se actualiza a 0', () {
      final item = CartItem(product: testProduct, quantity: 1);
      cartService.addItem(item);

      cartService.updateQuantity(testProduct.id, 0);
      expect(cartService.items, isEmpty);
    });

    test('debe verificar si un producto está en el carrito', () {
      expect(cartService.isInCart(testProduct.id), false);

      final item = CartItem(product: testProduct, quantity: 1);
      cartService.addItem(item);

      expect(cartService.isInCart(testProduct.id), true);
      expect(cartService.isInCart(testProduct2.id), false);
    });

    test('debe obtener la cantidad de un producto', () {
      expect(cartService.getQuantity(testProduct.id), 0);

      final item = CartItem(product: testProduct, quantity: 3);
      cartService.addItem(item);

      expect(cartService.getQuantity(testProduct.id), 3);
    });

    test('debe limpiar el carrito', () {
      final item1 = CartItem(product: testProduct, quantity: 1);
      final item2 = CartItem(product: testProduct2, quantity: 1);

      cartService.addItem(item1);
      cartService.addItem(item2);

      expect(cartService.items.length, 2);

      cartService.clear();
      expect(cartService.items, isEmpty);
      expect(cartService.itemCount, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('debe retornar una lista inmutable de items', () {
      final item = CartItem(product: testProduct, quantity: 1);
      cartService.addItem(item);

      final items = cartService.items;
      expect(() => items.add(CartItem(product: testProduct2, quantity: 1)),
          throwsA(isA<UnsupportedError>()));
    });
  });
}
