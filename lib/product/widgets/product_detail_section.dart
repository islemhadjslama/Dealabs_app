import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../shared/managers/product_manager.dart';

class ProductDetailSection extends StatelessWidget {
  final Product product;

  const ProductDetailSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productManager = Provider.of<ProductManager>(context);
    final isFavorite = product.isFavorite;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title + Favorite Button
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
                onPressed: () {
                  productManager.toggleFavorite(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? "Removed from favorites"
                            : "Added to favorites",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 🔹 Price + Discount
          Row(
            children: [
              Text(
             "TND ${product.discountedPrice}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              if (product.discountPercentage > 0)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${product.discountPercentage}% off',
                    style:
                    const TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '\$${product.originalPrice}',
                style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Description
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(product.description),

          const SizedBox(height: 12),

          // 🔹 Specifications
          if (product.specifications.isNotEmpty) ...[
            const Text(
              'Specifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: product.specifications
                  .map((spec) => Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text(spec)),
                ],
              ))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          // 🔹 Seller Info
          Row(
            children: [
              const Icon(Icons.store, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${product.sellerName} • ${product.sellerLocation}'),
            ],
          ),

          const SizedBox(height: 8),

          // 🔹 Stock & Shipping
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
                    Icon(Icons.local_shipping,
                        size: 16, color: Colors.blueAccent),
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
