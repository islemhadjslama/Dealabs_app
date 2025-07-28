
import 'package:flutter/foundation.dart';
import '../data/demo_products.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [
    CartItem(product: demoProducts[0], quantity: 1),
    CartItem(product: demoProducts[1], quantity: 2),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners(); // 🔹 VERY IMPORTANT
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.product.discountedPrice * item.quantity);
}
