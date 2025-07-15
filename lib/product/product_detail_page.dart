import 'package:flutter/material.dart';
import 'package:newapp/product/widgets/add_to_cart_button.dart';
import 'package:newapp/product/widgets/nav_bar.dart';
import 'package:newapp/product/widgets/product_detail_section.dart';
import 'package:newapp/product/widgets/product_image_carousel.dart';

import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});
  void _handleAddToCart() {
    print("Add to Cart clicked");
    // Your logic here
  }

  void _handleCheckout() {
    print("Checkout clicked");
    // Your logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImageCarousel(images: product.images),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ProductDetailSection(product: product),

            ),

          ],
        ),
      ),


      bottomNavigationBar: AddToCartButton(
        onAddToCart: _handleAddToCart,
        onCheckout: _handleCheckout,
      ),
    );
  }
}
