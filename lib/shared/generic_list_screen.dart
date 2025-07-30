import 'package:flutter/material.dart';
import 'package:newapp/shared/nav_bar.dart';
import 'package:newapp/shared/product_card.dart';
import '../models/product.dart';
import '../product/product_detail_page.dart';

class GenericListScreen extends StatefulWidget {
  final String title;
  final List<Product> products;

  const GenericListScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  State<GenericListScreen> createState() => _GenericListScreenState();
}

class _GenericListScreenState extends State<GenericListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavBar(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: widget.products.isEmpty
            ? const Center(child: Text("No items found"))
            : GridView.builder(
          itemCount: widget.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final product = widget.products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailPage(product: product),
                  ),
                );
              },
              child: ProductCard(product: product),
            );
          },
        ),
      ),
    );
  }
}
