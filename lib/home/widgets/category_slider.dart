import 'package:flutter/material.dart';
import 'package:newapp/shared/generic_list_screen.dart';
import '../../data/demo_categories.dart';
import '../../data/demo_products.dart';
import '../../models/category.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 140, // Adjust this value if needed
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: demoCategories.map((category) {
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
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      category.icon,
                      color: Colors.deepOrange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

