import 'package:flutter/material.dart';
import '../../models/product.dart';

class CartItemCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final int quantity;
  final VoidCallback onToggleSelect;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onTap; // ✅ new optional onTap callback

  const CartItemCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.quantity,
    required this.onToggleSelect,
    required this.onIncrement,
    required this.onDecrement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (_) => onToggleSelect(),
            ),
            Image.asset(
              product.images.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "IDR ${product.discountedPrice}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (product.discountPercentage > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${product.discountPercentage}% off",
                            style: const TextStyle(
                                fontSize: 10, color: Colors.red),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add, size: 20),
                ),
                Text('$quantity'),
                IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
