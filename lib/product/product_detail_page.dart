import 'package:flutter/material.dart';
import 'package:newapp/product/widgets/add_to_cart_button.dart';
import 'package:newapp/product/widgets/nav_bar.dart';
import 'package:newapp/product/widgets/product_detail_section.dart';
import 'package:newapp/product/widgets/product_image_carousel.dart';
import 'package:provider/provider.dart';

import '../checkout/checkout_screen.dart';
import '../models/order_product.dart';
import '../models/product.dart';
import '../shared/managers/cart_manager.dart';
import '../shared/managers/order_manager.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  void _handleAddToCart(BuildContext context) {
    Provider.of<CartManager>(context, listen: false).addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} added to cart")),
    );
  }

  void _handleCheckout(BuildContext context) {
    final products = [
      OrderProduct(
        productId: product.id,
        productName: product.name,
        productImage: product.images.first,
        quantity: 1,
        subtotal: product.discountedPrice,
      ),
    ];

    final totalAmount = product.discountedPrice;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          products: products,
          totalAmount: totalAmount,
        ),
      ),
    );
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
              padding: const EdgeInsets.all(16.0),
              child: ProductDetailSection(product: product),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AddToCartButton(
        onAddToCart: () => _handleAddToCart(context),
        onCheckout: () => _handleCheckout(context),
      ),
    );
  }
}
