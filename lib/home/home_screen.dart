import 'package:flutter/material.dart';
import 'package:newapp/services/products_services.dart';
import 'package:newapp/home/widgets/advertizing_card.dart';
import 'package:newapp/home/widgets/category_slider.dart';
import 'package:newapp/home/widgets/flash_deal_section.dart';
import 'package:newapp/home/widgets/custom_search_bar.dart';
import '../data/demo_products.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductsService _productsService = ProductsService();
  List<Product> _allProducts = [];
  List<Product> _flashSaleProducts = [];
  List<Product> _bestDealsProducts = [];
  List<Product> _newArrivalsProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      // Load all products from database
      final allProducts = await _productsService.getAllProducts();

      // If no products in database, fall back to demo products
      if (allProducts.isEmpty) {
        setState(() {
          _allProducts = demoProducts;
          _flashSaleProducts = demoProducts;
          _bestDealsProducts = demoProducts;
          _newArrivalsProducts = demoProducts;
          _isLoading = false;
        });
        return;
      }

      // Use database products
      setState(() {
        _allProducts = allProducts;

        // Create different product lists for variety
        _flashSaleProducts = allProducts.take(3).toList();
        _bestDealsProducts = allProducts.reversed.take(3).toList();
        _newArrivalsProducts =
            allProducts.where((p) => p.isFavorite).take(3).toList();

        // If not enough favorites, use all products
        if (_newArrivalsProducts.length < 3) {
          _newArrivalsProducts = allProducts.take(3).toList();
        }

        _isLoading = false;
      });

      print('✅ Loaded ${allProducts.length} products from database');
    } catch (e) {
      print('Error loading products: $e');
      // Fall back to demo products on error
      setState(() {
        _allProducts = demoProducts;
        _flashSaleProducts = demoProducts;
        _bestDealsProducts = demoProducts;
        _newArrivalsProducts = demoProducts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomSearchBar(),
              ),
              const SizedBox(height: 16),

              // ✅ Updated CategorySlider with database products
              CategorySlider(allProducts: _allProducts),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AdvertisingCard(),
              ),
              const SizedBox(height: 20),

              FlashDealsSection(
                title: 'Flash Sales',
                products: _flashSaleProducts,
                countdown: const Duration(hours: 1, minutes: 30),
              ),
              FlashDealsSection(
                title: 'Best Deals',
                products: _bestDealsProducts,
                countdown: const Duration(hours: 4),
              ),
              FlashDealsSection(
                title: 'New Arrivals',
                products: _newArrivalsProducts,
                countdown: const Duration(hours: 12),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
