import 'package:flutter/material.dart';
import '../../data/demo_products.dart';
import '../../models/product.dart';

class ProductManager extends ChangeNotifier {
  final List<Product> _products =  List.from(demoProducts);

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  void toggleFavorite(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
  }
}
