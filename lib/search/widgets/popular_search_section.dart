import 'package:flutter/material.dart';
import 'package:newapp/search/widgets/popular_product_tile.dart';
import '../../models/product.dart';

class PopularSearchSection extends StatelessWidget {
  final List<Product> products;

  const PopularSearchSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final displayedProducts = products.take(4).toList(); // Only first 4

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Search",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2, // Adjust for your tile proportions
            children: displayedProducts
                .map((product) => PopularProductTile(product: product))
                .toList(),
          ),
        ],
      ),
    );
  }
}
