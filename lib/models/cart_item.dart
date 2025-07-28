import 'package:newapp/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected; // optional: used only in cart

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isSelected = false,
  });
}
