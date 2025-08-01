import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newapp/home/widgets/advertizing_card.dart';
import 'package:newapp/home/widgets/category_slider.dart';
import 'package:newapp/home/widgets/flash_deal_section.dart';
import 'package:newapp/home/widgets/custom_search_bar.dart';
import '../data/demo_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

              // ✅ New fixed CategorySlider
              const CategorySlider(),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AdvertisingCard(),
              ),
              const SizedBox(height: 20),

              FlashDealsSection(
                title: 'Flash Sales',
                products: demoProducts,
                countdown: const Duration(hours: 1, minutes: 30),
              ),
              FlashDealsSection(
                title: 'Best Deals',
                products: demoProducts,
                countdown: const Duration(hours: 4),
              ),
              FlashDealsSection(
                title: 'New Arrivals',
                products: demoProducts,
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
