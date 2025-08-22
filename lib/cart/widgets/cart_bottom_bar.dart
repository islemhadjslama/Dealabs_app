import 'package:flutter/material.dart';

class CartBottomBar extends StatelessWidget {
  final bool allSelected;
  final VoidCallback onToggleAll;
  final int total;
  final VoidCallback onCheckout;

  const CartBottomBar({
    super.key,
    required this.allSelected,
    required this.onToggleAll,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: (_) => onToggleAll(),
            activeColor: Colors.orange,
          ),
          const Text(
            "Select All",
            style: TextStyle(color: Colors.black),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "$total TND",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text("Checkout"),
          ),
        ],
      ),
    );
  }
}

