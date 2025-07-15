
import 'package:flutter/material.dart';
import 'package:newapp/search/widgets/popular_product_tile.dart';
import '../../models/product.dart';
class PopularSearchSection extends StatelessWidget {
  final List<Product> products;

  const PopularSearchSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final displayedProducts = products.take(4).toList(); // Only first 4

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Search",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: displayedProducts
              .map((product) => PopularProductTile(product: product))
              .toList(),
        ),
      ],
    );
  }
}
