import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/favorite_service.dart';
import '../../services/auth_service.dart';
import '../database/db_models.dart';
import '../wishlist/widgets/favorite_product_card.dart';
import '../services/cart_service.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final AuthService _authService = AuthService();
  final CartService _cartService = CartService();

  String? _userId;
  List<Product> _favoriteProducts = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = await _authService.currentUser();
    if (user == null) return;

    _userId = user.id;

    final favoriteMaps = await _favoriteService.getFavorites(_userId!);
    final favorites = favoriteMaps.map((map) => ProductDbExtension.fromDbMap(map)).toList();

    setState(() {
      _favoriteProducts = favorites;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(Product product) async {
    if (_userId == null) return;

    final isFav = await _favoriteService.isFavorite(_userId!, product.id);
    if (isFav) {
      await _favoriteService.removeFavorite(_userId!, product.id);
      setState(() {
        _favoriteProducts.removeWhere((p) => p.id == product.id);
      });
    } else {
      await _favoriteService.addFavorite(_userId!, product.id);
      setState(() {
        _favoriteProducts.add(product);
      });
    }
  }

  /// Updated Add to Cart using CartService
  Future<void> _addToCart(BuildContext context, Product product) async {
    try {
      await _cartService.addToCart(product);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} added to cart"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add ${product.name} to cart"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _favoriteProducts.isEmpty
          ? const Center(child: Text("No favorite products yet"))
          : ListView.builder(
        itemCount: _favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = _favoriteProducts[index];
          return FavoriteProductCard(
            product: product,
            onToggleFavorite: () => _toggleFavorite(product),
            onAddToCart: () => _addToCart(context, product),
          );
        },
      ),
    );
  }
}

