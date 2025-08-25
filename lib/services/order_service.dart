import 'package:newapp/database/db_models.dart';

import '../models/order.dart';
import '../models/order_product.dart';
import '../database/db_helper.dart';
import 'auth_service.dart';

class OrderService {
  final _dbHelper = DatabaseHelper();
  final _authService = AuthService();

  // Create a new order using the current logged-in user
  Future<void> createOrder({
    required List<OrderProduct> products,
    required int totalAmount,
    required String shippingAddress,
    String paymentMethod = 'Cash',
    int shippingFee = 0,
    int discount = 0,
  }) async {
    final user = await _authService.currentUser();
    if (user == null) throw Exception('No logged in user');

    final db = await _dbHelper.database;
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();

    await db.insert('orders', {
      'id': orderId,
      'user_id': user.id,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'placement_date': now,
      'delivery_date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'status': 'Processing',
      'shipping_fee': shippingFee,
      'discount': discount,
      'created_at': now,
      'updated_at': now,
    });

    for (var product in products) {
      await db.insert('order_products', product.toDbMap(orderId));
    }
  }

  // Get orders of the current user
  Future<List<Order>> getOrders() async {
    final user = await _authService.currentUser();
    if (user == null) return [];

    final db = await _dbHelper.database;

    final orderMaps = await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [user.id],
      orderBy: 'placement_date DESC',
    );

    final orders = <Order>[];
    for (var orderMap in orderMaps) {
      final productsMaps = await db.query(
        'order_products',
        where: 'order_id = ?',
        whereArgs: [orderMap['id']],
      );
      final products = productsMaps.map((p) => OrderProductDbExtension.fromDbMap(p)).toList();
      orders.add(OrderDbExtension.fromDbMap(orderMap, products));
    }

    return orders;
  }
}
