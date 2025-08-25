import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import 'widgets/order_card.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() => _isLoading = true);
    final orders = await _orderService.getOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(child: Text("No orders yet."))
          : RefreshIndicator(
        onRefresh: _refreshOrders,
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) => OrderCard(order: _orders[index]),
        ),
      ),
    );
  }
}
