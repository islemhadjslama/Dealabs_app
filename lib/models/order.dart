import 'order_product.dart';

class Order {
  final String id;
  final List<OrderProduct> products;
  final int totalAmount;
  final String paymentMethod;
  final String shippingAddress;
  final DateTime placementDate;
  final DateTime deliveryDate;
  final String status;
  final int shippingFee;
  final int discount;
  final String userId;

  Order({
    required this.id,
    required this.products,
    required this.totalAmount,
    this.paymentMethod = 'Cash',
    required this.shippingAddress,
    required this.placementDate,
    required this.deliveryDate,
    required this.status,
    this.shippingFee = 0,
    this.discount = 0,
    required this.userId,
  });
}
