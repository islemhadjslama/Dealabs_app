import 'package:flutter/material.dart';
import 'package:newapp/transaction/widgets/order_card.dart';
import 'package:provider/provider.dart';
import '../shared/order_manager.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderManager = Provider.of<OrderManager>(context); // ✅ Listen for updates
    final orders = orderManager.orders;

    return Scaffold(
      body: orders.isEmpty
          ? const Center(child: Text("No orders yet."))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}


