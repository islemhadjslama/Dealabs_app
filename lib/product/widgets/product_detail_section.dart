import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/auth_service.dart';
import '../../services/favorite_service.dart';

class ProductDetailSection extends StatefulWidget {
  final Product product;
  final VoidCallback? onFavoriteChanged; // 🔹 callback to refresh parent

  const ProductDetailSection({
    super.key,
    required this.product,
    this.onFavoriteChanged,
  });

  @override
  State<ProductDetailSection> createState() => _ProductDetailSectionState();
}

class _ProductDetailSectionState extends State<ProductDetailSection> {
  final _favoriteService = FavoriteService();
  final _authService = AuthService();

  bool _isFavorite = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    final user = await _authService.currentUser();
    if (user == null) return;

    _userId = user.id;
    final fav = await _favoriteService.isFavorite(_userId!, widget.product.id);

    setState(() {
      _isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in.")),
      );
      return;
    }

    if (_isFavorite) {
      await _favoriteService.removeFavorite(_userId!, widget.product.id);
    } else {
      await _favoriteService.addFavorite(_userId!, widget.product.id);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

    // 🔹 Notify parent to refresh
    if (widget.onFavoriteChanged != null) {
      widget.onFavoriteChanged!();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? "Added to favorites" : "Removed from favorites",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Favorite Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Price + Discount
          Row(
            children: [
              Text(
                "TND ${widget.product.discountedPrice}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              if (widget.product.discountPercentage > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${widget.product.discountPercentage}% off',
                    style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '\$${widget.product.originalPrice}',
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
          Text(widget.product.description),
          const SizedBox(height: 12),
          // Specifications
          if (widget.product.specifications.isNotEmpty) ...[
            const Text(
              'Specifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.product.specifications
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
          // Seller Info
          Row(
            children: [
              const Icon(Icons.store, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${widget.product.sellerName} • ${widget.product.sellerLocation}'),
            ],
          ),
          const SizedBox(height: 8),
          // Stock & Shipping
          Row(
            children: [
              Icon(
                widget.product.inStock ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: widget.product.inStock ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(widget.product.inStock ? 'In stock' : 'Out of stock'),
              const SizedBox(width: 16),
              if (widget.product.freeShipping)
                const Row(
                  children: [
                    Icon(Icons.local_shipping, size: 16, color: Colors.blueAccent),
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
