class OrderProduct {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final int subtotal;

  OrderProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.subtotal,
  });
}
