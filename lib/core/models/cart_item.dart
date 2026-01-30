import 'package:conectify/conectify.dart';

/// Ítem del carrito. Usa [Product] del paquete conectify.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
