
import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onCheckout;

  const AddToCartButton({
    Key? key,
    required this.onAddToCart,
    required this.onCheckout,
  }) : super(key: key);

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onAddToCart, // ✅ fix here
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFFFF5722),
                side: const BorderSide(color: Color(0xFFFF5722)),
              ),
              child: const Text("Add to Cart"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: widget.onCheckout, // ✅ fix here
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5722),
                foregroundColor: Colors.white,
              ),
              child: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}

