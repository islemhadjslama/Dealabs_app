import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductDetailSection extends StatefulWidget {
  final Product product;

  const ProductDetailSection({super.key, required this.product});

  @override
  State<ProductDetailSection> createState() => _ProductDetailSectionState();
}

class _ProductDetailSectionState extends State<ProductDetailSection> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // You can add actual logic here (e.g., call API or update global state)
    print('${widget.product.name} isFavorite: $isFavorite');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Favorite Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: toggleFavorite,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Prices
          Row(
            children: [
              Text(
                "IDR ${product.discountedPrice}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              if (product.discountPercentage > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${product.discountPercentage}% off',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                'IDR ${product.originalPrice}',
                style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(product.description),

          const SizedBox(height: 12),

          // Specs
          if (product.specifications.isNotEmpty) ...[
            const Text(
              'Specifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...product.specifications.map((spec) => Text('• $spec')),
            const SizedBox(height: 12),
          ],

          // Seller info
          Row(
            children: [
              const Icon(Icons.store, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${product.sellerName} • ${product.sellerLocation}'),
            ],
          ),

          const SizedBox(height: 8),

          // Stock + Shipping
          Row(
            children: [
              Icon(
                product.inStock ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: product.inStock ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(product.inStock ? 'In stock' : 'Out of stock'),
              const SizedBox(width: 16),
              if (product.freeShipping)
                const Row(
                  children: [
                    Icon(Icons.local_shipping, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text('Free Shipping'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
