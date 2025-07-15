import 'package:flutter/material.dart';
import 'package:newapp/home/widgets/advertizing_card.dart';
import 'package:newapp/home/widgets/bottom_navbar.dart';
import 'package:newapp/home/widgets/category_slider.dart';
import 'package:newapp/home/widgets/flash_deal_section.dart';
import 'package:newapp/home/widgets/nav_bar.dart';
import 'package:newapp/models/product.dart';
import 'package:newapp/home/widgets/custom_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Nike Air Max 270',
      description: 'Comfortable and stylish sneakers for everyday wear.',
      originalPrice: 2200000,
      discountedPrice: 1790000,
      discountPercentage: 19,
      images: [
        'assets/products/nike1.webp',
        'assets/products/nike2.webp',
      ],
      rating: 4.6,
      reviews: 1425,
      brand: 'Nike',
      category: 'Shoes',
      sellerName: 'Nike Official Store',
      sellerLocation: 'Jakarta',
      inStock: true,
      freeShipping: true,
      specifications: [
        'Breathable mesh upper',
        'Air Max heel unit',
        'Rubber outsole',
      ],
      tags: ['men', 'running', '2024', 'new'],
    ),
    Product(
      id: '2',
      name: 'Adidas Ultraboost 21',
      description: 'High-performance running shoes with responsive cushioning.',
      originalPrice: 2500000,
      discountedPrice: 1990000,
      discountPercentage: 20,
      images: [
        'assets/products/adidas2.jpg',
        'assets/products/adidas2.webp',
      ],
      rating: 4.8,
      reviews: 990,
      brand: 'Adidas',
      category: 'Shoes',
      sellerName: 'Adidas Store',
      sellerLocation: 'Bandung',
      inStock: true,
      freeShipping: false,
      specifications: [
        'Primeknit+ textile upper',
        'Boost midsole',
        'Stretchweb outsole',
      ],
      tags: ['running', 'boost', 'adidas'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NavBar(),
              CustomSearchBar(),
              CategorySlider(),
              const AdvertisingCard(),

              FlashDealsSection(
                title: 'Flash Sales',
                products: products,
                countdown: const Duration(hours: 1, minutes: 30),
              ),
              FlashDealsSection(
                title: 'Best Deals',
                products: products,
                countdown: const Duration(hours: 4),
              ),
              FlashDealsSection(
                title: 'New Arrivals',
                products: products,
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
