import '../../domain/entities/entities.dart';

/// Modelo para items del carrito
class CartItem {
  final ProductEntity product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    ProductEntity? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
