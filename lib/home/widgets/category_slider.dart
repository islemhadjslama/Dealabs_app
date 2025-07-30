import 'package:flutter/material.dart';
import 'package:newapp/shared/generic_list_screen.dart';
import '../../data/demo_categories.dart';
import '../../data/demo_products.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110, // ✅ Reduced height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: demoCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = demoCategories[index];

          return GestureDetector(
            onTap: () {
              final filteredProducts = demoProducts
                  .where((product) => product.category == category.title)
                  .toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GenericListScreen(
                    title: category.title,
                    products: filteredProducts,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    category.icon,
                    color: Colors.deepOrange,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 70, // ✅ Ensures text wraps properly
                  child: Text(
                    category.title,
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
