import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category(this.name, this.icon);
}

class CategorySlider extends StatelessWidget {
  final List<Category> categories = [
    Category('Electronic', Icons.tv),
    Category('Food & Drink', Icons.fastfood),
    Category('Accessories', Icons.watch),
    Category('Beauty', Icons.brush),
    Category('Furniture', Icons.chair),
    Category('Fashion', Icons.shopping_bag),
    Category('Health', Icons.favorite),
    Category('Stationery', Icons.menu_book),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: categories.map((category) {
          return Column(
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
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

