import '../models/order.dart';
import '../models/order_product.dart';
import 'demo_products.dart';

final List<Order> demoOrders = [
  Order(
    id: 'o1',
    userId: 'u1',
    products: [
      OrderProduct(
        productId: demoProducts[0].id,
        productName: demoProducts[0].name,
        productImage: demoProducts[0].images[0],
        quantity: 1,
        subtotal: demoProducts[0].discountedPrice ,
      ),
      OrderProduct(
        productId: demoProducts[2].id,
        productName: demoProducts[2].name,
        productImage: demoProducts[2].images[0],
        quantity: 2,
        subtotal: demoProducts[2].discountedPrice * 2,
      ),
    ],
    totalAmount: demoProducts[0].discountedPrice + demoProducts[2].discountedPrice * 2,
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
