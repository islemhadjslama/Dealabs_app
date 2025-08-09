import 'package:flutter/material.dart';
import 'package:newapp/services/products_services.dart';
import 'package:newapp/shared/generic_list_screen.dart';
import '../../data/demo_categories.dart';
import '../../data/demo_products.dart';
import '../../models/product.dart';

class CategorySlider extends StatefulWidget {
  final List<Product> allProducts;

  const CategorySlider({super.key, required this.allProducts});

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  final ProductsService _productsService = ProductsService();
  List<String> _categories = [];
  Map<String, int> _categoryProductCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      // Get unique categories from database
      final categories = await _productsService.getUniqueCategories();
      final categoryProductCounts =
          await _productsService.getProductCountByCategory();

      setState(() {
        _categories = categories;
        _categoryProductCounts = categoryProductCounts;
        _isLoading = false;
      });

      print('✅ Loaded categories: $_categories');
      print('✅ Category counts: $_categoryProductCounts');
    } catch (e) {
      print('Error loading categories: $e');
      // Fall back to demo categories
      setState(() {
        _categories = demoCategories.map((c) => c.title).toList();
        _isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String category) {
    // Map categories to icons
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.phone_android;
      case 'sports':
        return Icons.sports_soccer;
      case 'furniture':
        return Icons.chair;
      case 'clothing':
        return Icons.checkroom;
      case 'books':
        return Icons.book;
      case 'home':
        return Icons.home;
      case 'beauty':
        return Icons.face;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 110,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final categoryName = _categories[index];
          final productCount = _categoryProductCounts[categoryName] ?? 0;

          return GestureDetector(
            onTap: () async {
              // Show loading while fetching products
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) =>
                        const Center(child: CircularProgressIndicator()),
              );

              try {
                // Get products for this category from database
                final filteredProducts = await _productsService
                    .getProductsByCategory(categoryName);

                // Close loading dialog
                Navigator.pop(context);

                // Navigate to category screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => GenericListScreen(
                          title: categoryName,
                          products: filteredProducts,
                        ),
                  ),
                );
              } catch (e) {
                // Close loading dialog
                Navigator.pop(context);

                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading products: $e')),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(
                        _getCategoryIcon(categoryName),
                        color: Colors.deepOrange,
                        size: 26,
                      ),
                    ),
                    if (productCount > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            productCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 70,
                  child: Text(
                    categoryName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
