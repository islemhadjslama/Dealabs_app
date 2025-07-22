import 'package:flutter/material.dart';
import 'package:newapp/search/widgets/popular_search_section.dart';
import 'package:newapp/search/widgets/recommended_section.dart';

import '../models/product.dart';
import '../search/widgets/nav_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Product> demoProducts = [
    Product(
      id: '1',
      name: 'Fossil Watch',
      description: 'Elegant wristwatch.',
      originalPrice: 1200000,
      discountedPrice: 900000,
      discountPercentage: 25,
      images: ['assets/applogo.png'],
      rating: 4.8,
      reviews: 300,
      brand: 'Fossil',
      category: 'Accessories',
      sellerName: 'Fossil Store',
      sellerLocation: 'Jakarta',
      inStock: true,
      freeShipping: true,
      specifications: [],
      tags: ['watch', 'luxury'],
        isFavorite: true

    ),
    Product(
      id: '2',
      name: 'iPhone 14 Pro',
      description: 'Latest Apple smartphone.',
      originalPrice: 22000000,
      discountedPrice: 21000000,
      discountPercentage: 5,
      images: ['assets/applogo.png'],
      rating: 4.9,
      reviews: 500,
      brand: 'Apple',
      category: 'Phones',
      sellerName: 'Apple Store',
      sellerLocation: 'Tunis',
      inStock: true,
      freeShipping: true,
      specifications: [],
      tags: ['iphone', 'smartphone'],
        isFavorite: true

    ),
    Product(
      id: '3',
      name: 'Gaming Chair',
      description: 'Comfortable ergonomic chair.',
      originalPrice: 3500000,
      discountedPrice: 2990000,
      discountPercentage: 15,
      images: ['assets/applogo.png'],
      rating: 4.6,
      reviews: 240,
      brand: 'Racer',
      category: 'Furniture',
      sellerName: 'ChairZone',
      sellerLocation: 'Sfax',
      inStock: true,
      freeShipping: false,
      specifications: [],
      tags: ['gaming', 'chair'],
        isFavorite: true

    ),
    Product(
      id: '4',
      name: 'New Balance Shoes',
      description: 'Casual & sporty shoes.',
      originalPrice: 1800000,
      discountedPrice: 1600000,
      discountPercentage: 11,
      images: ['assets/applogo.png'],
      rating: 4.7,
      reviews: 450,
      brand: 'New Balance',
      category: 'Footwear',
      sellerName: 'NB Store',
      sellerLocation: 'Sousse',
      inStock: true,
      freeShipping: true,
      specifications: [],
      tags: ['shoes', 'sport'],
        isFavorite: true

    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NavBar(),
      body:  ListView(
          children: [
            const SizedBox(height: 20),
            PopularSearchSection(products: demoProducts),
            const SizedBox(height: 20),
            RecommendedSection(products: demoProducts),
          ],
        ),

    );
  }
}
