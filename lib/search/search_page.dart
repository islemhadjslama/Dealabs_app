import 'package:flutter/material.dart';
import 'package:newapp/search/widgets/popular_search_section.dart';
import 'package:newapp/search/widgets/recommended_section.dart';
import '../data/demo_products.dart';
import '../models/product.dart';
import '../search/widgets/nav_bar.dart';
import '../services/products_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductsService _productsService = ProductsService();

  List<Product> _allProducts = [];
  List<Product> _popularProducts = [];
  List<Product> _recommendedProducts = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final allProducts = await _productsService.getAllProducts();

      if (allProducts.isEmpty) {
        _useDemoProducts();
        return;
      }

      setState(() {
        _allProducts = allProducts;

        // Popular → products with high reviews
        _popularProducts = allProducts
            .where((p) => p.reviews > 50) // arbitrary threshold
            .toList()
          ..sort((a, b) => b.reviews.compareTo(a.reviews));
        _popularProducts = _popularProducts.take(4).toList();

        // Recommended → products with high rating
        _recommendedProducts = allProducts
            .where((p) => p.rating >= 4.0)
            .toList()
          ..sort((a, b) => b.rating.compareTo(a.rating));
        _recommendedProducts = _recommendedProducts.toList();

        _isLoading = false;
      });

      print("✅ SearchPage loaded ${allProducts.length} products from DB");
    } catch (e) {
      print("❌ Error loading products in SearchPage: $e");
      _useDemoProducts();
    }
  }

  void _useDemoProducts() {
    setState(() {
      _allProducts = demoProducts;
      _popularProducts = demoProducts.take(4).toList();
      _recommendedProducts = demoProducts.take(5).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NavBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          const SizedBox(height: 10),
          PopularSearchSection(products: _popularProducts),
          const SizedBox(height: 10),
          RecommendedSection(products: _recommendedProducts),
        ],
      ),
    );
  }
}

