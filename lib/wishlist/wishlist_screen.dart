import 'package:flutter/material.dart';
import 'package:newapp/wishlist/widgets/favorite_product_card.dart';

import '../data/demo_products.dart';
import '../models/product.dart';
import '../shared/cart_manager.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<Product> favoriteProducts;
  final CartManager _cartManager = CartManager(); // instance of CartManager

  @override
  void initState() {
    super.initState();
    // Get only favorite products
    favoriteProducts =
        demoProducts.where((product) => product.isFavorite).toList();
  }

  void toggleFavorite(Product product) {
    setState(() {
      final index = demoProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        demoProducts[index].isFavorite = !demoProducts[index].isFavorite;
      }

      // Update local list
      favoriteProducts =
          demoProducts.where((p) => p.isFavorite).toList();
    });
  }

  void addToCart(Product product) {
    _cartManager.addToCart(product); // Use CartManager

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} added to cart")),
    );

  }

  void openProductDetails(Product product) {
    Navigator.pushNamed(
      context,
      '/product',
      arguments: product,
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
          return GestureDetector(
            onTap: () => openProductDetails(product),
            child: FavoriteProductCard(
              product: product,
              onToggleFavorite: () => toggleFavorite(product),
              onAddToCart: () => addToCart(product),
            ),
          );
        },
      ),
    );
  }
}
