import 'package:flutter/material.dart';
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

  List<Product> get _favoriteProducts =>
      demoProducts.where((product) => product.isFavorite).toList();

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
        preferredSize: const Size.fromHeight(70), // Set your desired height
        child: const LogoNavBar(),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
