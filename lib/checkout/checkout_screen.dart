import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_product.dart';
import '../shared/order_manager.dart';
import '../data/demo_user.dart'; // your demoUser import

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
    // Pre-fill shipping address with demoUser address
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
      body: Padding(
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
                    trailing: Text("\$${p.subtotal}"),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Total: \$${widget.totalAmount}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
