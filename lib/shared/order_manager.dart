import 'package:flutter/foundation.dart';
import '../data/demo_products.dart';
import '../models/order.dart';
import '../models/order_product.dart';

class OrderManager extends ChangeNotifier {
  final List<Order> _orders = [
    Order(
      id: 'o1',
      userId: 'u1',
      products: [
        OrderProduct(
          productId: demoProducts[0].id,
          productName: demoProducts[0].name,
          productImage: demoProducts[0].images[0],
          quantity: 1,
          subtotal: demoProducts[0].discountedPrice,
        ),
        OrderProduct(
          productId: demoProducts[2].id,
          productName: demoProducts[2].name,
          productImage: demoProducts[2].images[0],
          quantity: 2,
          subtotal: demoProducts[2].discountedPrice * 2,
        ),
      ],
      totalAmount: demoProducts[0].discountedPrice +
          demoProducts[2].discountedPrice * 2,
      shippingAddress: '12 Rue Habib Bourguiba, Tunis',
      placementDate: DateTime(2025, 7, 1),
      deliveryDate: DateTime(2025, 7, 5),
      status: 'Delivered',
      shippingFee: 10,
      discount: 15,
    ),
    Order(
      id: 'o2',
      userId: 'u2',
      products: [
        OrderProduct(
          productId: demoProducts[1].id,
          productName: demoProducts[1].name,
          productImage: demoProducts[1].images[0],
          quantity: 3,
          subtotal: demoProducts[1].discountedPrice * 3,
        ),
      ],
      totalAmount: demoProducts[1].discountedPrice * 3,
      shippingAddress: '42 Avenue de France, Sfax',
      placementDate: DateTime(2025, 7, 10),
      deliveryDate: DateTime(2025, 7, 12),
      status: 'Pending',
      shippingFee: 5,
      discount: 0,
    ),
  ];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder({
    required List<OrderProduct> products,
    required int totalAmount,
    required String userId,
    String paymentMethod = 'Cash',
    required String shippingAddress,
    int shippingFee = 0,
    int discount = 0,
  }) {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      products: products,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
      placementDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
      status: 'Processing',
      shippingFee: shippingFee,
      discount: discount,
      userId: userId,
    );

    _orders.insert(0, newOrder);
    notifyListeners(); // ✅ now works because we extend ChangeNotifier
  }
}
