import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/managers/product_manager.dart';
import '../wishlist/widgets/favorite_product_card.dart';
import '../shared/managers/cart_manager.dart';
import '../models/product.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  void _addToCart(BuildContext context, Product product) {
    Provider.of<CartManager>(context, listen: false).addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productManager = Provider.of<ProductManager>(context);
    final favoriteProducts = productManager.favoriteProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: favoriteProducts.isEmpty
          ? const Center(child: Text("No favorite products yet"))
          : ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product',
                arguments: product,
              );
            },
            child: FavoriteProductCard(
              product: product,
              onToggleFavorite: () =>
                  productManager.toggleFavorite(product.id),
              onAddToCart: () => _addToCart(context, product),
            ),
          );
        },
      ),
    );
  }
}
