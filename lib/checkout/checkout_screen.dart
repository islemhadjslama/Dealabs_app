import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_product.dart';
import '../shared/managers/order_manager.dart';
import '../data/demo_user.dart';

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

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: demoUser.address);
  }

  void _placeOrder() {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a shipping address")),
      );
      return;
    }

    final orderManager = Provider.of<OrderManager>(context, listen: false);

    orderManager.addOrder(
      products: widget.products,
      totalAmount: widget.totalAmount,
      shippingAddress: _addressController.text,
      userId: demoUser.id,
      paymentMethod: "Cash",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Order placed successfully for ${demoUser.name}!")),
    );

    Navigator.pop(context);
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final p = widget.products[index];
                    return ListTile(
                      leading: Image.asset(p.productImage, width: 50, height: 50),
                      title: Text(
                        p.productName,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        "Qty: ${p.quantity}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: Text(
                        "${p.subtotal} TND", // ✅ Updated to TND
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Total: ${widget.totalAmount} TND", // ✅ Updated to TND
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Shipping Address",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Place Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

