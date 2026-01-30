import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

/// Servicio del carrito. Singleton.
class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(CartItem item) {
    final i = _items.indexWhere((e) => e.product.id == item.product.id);
    if (i >= 0) {
      _items[i].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((e) => e.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    final i = _items.indexWhere((e) => e.product.id == productId);
    if (i < 0) return;
    if (quantity <= 0) {
      _items.removeAt(i);
    } else {
      _items[i].quantity = quantity;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(int productId) =>
      _items.any((e) => e.product.id == productId);

  int getQuantity(int productId) {
    final i = _items.indexWhere((e) => e.product.id == productId);
    return i < 0 ? 0 : _items[i].quantity;
  }
}
