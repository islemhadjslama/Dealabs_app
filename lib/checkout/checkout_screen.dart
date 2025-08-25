import 'package:flutter/material.dart';
import '../models/order_product.dart';
import '../services/order_service.dart';

class CheckoutPage extends StatefulWidget {
  final List<OrderProduct> products;
  final int totalAmount;

  const CheckoutPage({
    super.key,
    required this.products,
    required this.totalAmount,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late TextEditingController _addressController;
  final OrderService _orderService = OrderService();
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
  }

  Future<void> _placeOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a shipping address")),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      await _orderService.createOrder(
        products: widget.products,
        totalAmount: widget.totalAmount,
        shippingAddress: _addressController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order placed successfully!")),
      );

      Navigator.pop(context, true); // Return "true" to indicate a new order
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    } finally {
      setState(() => _isPlacingOrder = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final p = widget.products[index];
                    return ListTile(
                      leading: Image.asset(p.productImage, width: 50, height: 50),
                      title: Text(p.productName),
                      subtitle: Text("Qty: ${p.quantity}"),
                      trailing: Text("${p.subtotal} TND"),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text("Total: ${widget.totalAmount} TND", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Shipping Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isPlacingOrder
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Place Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
