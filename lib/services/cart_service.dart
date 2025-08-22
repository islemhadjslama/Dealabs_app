import 'package:newapp/database/db_helper.dart';
import 'package:newapp/database/db_models.dart';
import 'package:newapp/services/products_services.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ProductsService _productService = ProductsService();

  CartService._internal();
  factory CartService() => _instance;

  final String tableName = 'cart_items';
  final String userId = 'user_001'; // replace with current logged-in user

  /// Add product to cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final existing = await _dbHelper.queryData(
      tableName,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, product.id],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      // Update quantity
      int newQty = existing.first['quantity'] + quantity;
      await _dbHelper.updateData(
        tableName,
        {'quantity': newQty, 'updated_at': DateTime.now().toIso8601String()},
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, product.id],
      );
    } else {
      // Insert new item
      await _dbHelper.insertData(tableName, CartItem(product: product, quantity: quantity, isSelected: true).toDbMap(userId));
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId) async {
    await _dbHelper.deleteData(
      tableName,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  /// Update quantity
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    await _dbHelper.updateData(
      tableName,
      {'quantity': quantity, 'updated_at': DateTime.now().toIso8601String()},
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  /// Toggle selection
  Future<void> toggleSelection(String productId) async {
    final row = await _dbHelper.queryData(
      tableName,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
      limit: 1,
    );
    if (row.isEmpty) return;

    final current = row.first['is_selected'] == 1 ? true : false;
    await _dbHelper.updateData(
      tableName,
      {'is_selected': current ? 0 : 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  /// Get all cart items
  Future<List<CartItem>> getCartItems() async {
    final cartRows = await _dbHelper.queryData(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    List<CartItem> items = [];

    for (final row in cartRows) {
      final product = await _productService.getProductById(row['product_id']);
      if (product != null) {
        items.add(CartItemDbExtension.fromDbMapWithProduct(row, product));
      }
    }

    return items;
  }

  /// Get total price of selected items
  Future<int> getTotal() async {
    final items = await getCartItems();
    return items
        .where((i) => i.isSelected)
        .fold<int>(0, (sum, i) => sum + i.product.discountedPrice * i.quantity);
  }


  /// Clear cart
  Future<void> clearCart() async {
    await _dbHelper.deleteData(tableName, where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Toggle selection of all cart items
  Future<void> toggleAllSelection(bool selectAll) async {
    final items = await getCartItems();
    for (var item in items) {
      await _dbHelper.updateData(
        tableName,
        {'is_selected': selectAll ? 1 : 0, 'updated_at': DateTime.now().toIso8601String()},
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, item.product.id],
      );
    }
  }

}

