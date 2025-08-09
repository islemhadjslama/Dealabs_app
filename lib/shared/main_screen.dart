import 'package:flutter/material.dart';
import 'package:newapp/services/products_services.dart';
import 'package:newapp/shared/fake_data.dart';
import 'package:newapp/shared/logo_nav_bar.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../transaction/transaction_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'bottom_navbar.dart';
import '../models/product.dart';
import '../data/demo_products.dart';
import '../data/demo_user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ProductsService _productsService = ProductsService();
  bool _isInitialized = false;

  List<Product> get _favoriteProducts =>
      demoProducts.where((product) => product.isFavorite).toList();

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    try {
      // Check if products already exist to avoid duplicates
      final existingProducts = await _productsService.getAllProducts();

      if (existingProducts.isEmpty) {
        // Create the products in database
        final success = await _productsService.createMultipleProducts(
          FakeData.sampleProducts,
        );

        if (success) {
          print('✅ Sample products created successfully');

          // Verify by getting products by category
          final electronicsProducts = await _productsService
              .getProductsByCategory('Electronics');
          final clothingProducts = await _productsService.getProductsByCategory(
            'Clothing',
          );

          print('📱 Electronics products: ${electronicsProducts.length}');
          print('👕 Clothing products: ${clothingProducts.length}');
        } else {
          print('❌ Failed to create sample products');
        }
      } else {
        print(
          'ℹ️  Products already exist in database (${existingProducts.length} products)',
        );
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing products: $e');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const HomeScreen(),
      const WishlistScreen(),
      const TransactionScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: const LogoNavBar(),
      ),
      body:
          _isInitialized
              ? IndexedStack(index: _selectedIndex, children: _screens)
              : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Setting up your app...'),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
