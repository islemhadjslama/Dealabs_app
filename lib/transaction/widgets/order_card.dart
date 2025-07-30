import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // ✅ White background
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Status pill (orange)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Dates
            Text("📅 Placed: ${formatDate(order.placementDate)}",
                style: const TextStyle(fontSize: 14)),
            Text("🚚 Delivery: ${formatDate(order.deliveryDate)}",
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),

            // ✅ Payment + Address
            Text("💳 Payment: ${order.paymentMethod}",
                style: const TextStyle(fontSize: 14)),
            Text("📍 Address: ${order.shippingAddress}",
                style: const TextStyle(fontSize: 14)),
            const Divider(height: 20),

            // ✅ Products list
            ...order.products.map((op) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      op.productImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${op.productName} (x${op.quantity})',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text('${op.subtotal} TND',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )),

            const Divider(height: 20),

            // ✅ Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Shipping Fee:"),
                Text("${order.shippingFee} TND"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Discount:"),
                Text("-${order.discount} TND"),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "${order.totalAmount} TND",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFF5722),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
