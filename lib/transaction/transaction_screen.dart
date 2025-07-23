import 'package:flutter/material.dart';
import 'package:newapp/transaction/widgets/order_card.dart';
import '../models/order.dart';
import '../data/demo_orders.dart'; // your list of demoOrders

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: demoOrders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: demoOrders[index]);
        },
      ),
    );
  }
}


