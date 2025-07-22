import 'package:flutter/material.dart';
import 'package:newapp/wishlist/widgets/favorite_product_card.dart';

import '../data/demo_products.dart';
import '../models/product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<Product> favoriteProducts;

  @override
  void initState() {
    super.initState();
    // Filter favorite products from demo data
    favoriteProducts =
        demoProducts.where((product) => product.isFavorite).toList();
  }

  void toggleFavorite(Product product) {
    setState(() {
      final index = demoProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        demoProducts[index].isFavorite = !demoProducts[index].isFavorite;
      }

      favoriteProducts =
          demoProducts.where((p) => p.isFavorite).toList(); // refresh list
    });
  }


  void addToCart(Product product) {
    // TODO: Implement real cart logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteProducts.isEmpty
          ? const Center(child: Text("No favorite products yet"))
          : ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return FavoriteProductCard(
            product: product,
            onToggleFavorite: () => toggleFavorite(product),
            onAddToCart: () => addToCart(product),
          );
        },
      ),
    );
  }
}


