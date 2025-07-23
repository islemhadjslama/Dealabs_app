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
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Chip(label: Text(order.status), backgroundColor: Colors.blue.shade100),
            ],
          ),
          const SizedBox(height: 10),
          Text('Placed: ${formatDate(order.placementDate)}'),
          Text('Delivery: ${formatDate(order.deliveryDate)}'),
          const SizedBox(height: 10),
          Text('Payment: ${order.paymentMethod}'),
          Text('Address: ${order.shippingAddress}'),
          const Divider(height: 20),
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
                  child: Text('${op.productName} (x${op.quantity})',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
                Text('${op.subtotal} dt'),
              ],
            ),
          )),
          const Divider(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Shipping Fee:'),
            Text('${order.shippingFee} dt'),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Discount:'),
            Text('-${order.discount} dt'),
          ]),
          const SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('${order.totalAmount} dt',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ]),
      ),
    );
  }
}
