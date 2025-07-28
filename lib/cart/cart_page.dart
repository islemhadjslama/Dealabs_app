import 'package:flutter/material.dart';
import 'package:newapp/cart/widgets/cart_bottom_bar.dart';
import 'package:newapp/cart/widgets/cart_item_card.dart';
import 'package:newapp/cart/widgets/cart_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../product/product_detail_page.dart';
import '../checkout/checkout_screen.dart';
import '../models/order_product.dart';
import '../shared/cart_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartManager cartManager;

  @override
  void initState() {
    super.initState();
    cartManager = CartManager();
  }

  int calculateTotal() {
    return cartManager.items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.product.discountedPrice * item.quantity);
  }

  bool get allSelected =>
      cartManager.items.isNotEmpty &&
          cartManager.items.every((item) => item.isSelected);

  void toggleAll() {
    final newValue = !allSelected;
    setState(() {
      for (var item in cartManager.items) {
        item.isSelected = newValue;
      }
    });
  }

  void _goToCheckout(BuildContext context) {
    final selectedItems =
    cartManager.items.where((item) => item.isSelected).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select items to checkout")),
      );
      return;
    }

    final orderProducts = selectedItems
        .map(
          (item) => OrderProduct(
        productId: item.product.id,
        productName: item.product.name,
        productImage: item.product.images.first,
        quantity: item.quantity,
        subtotal: item.product.discountedPrice * item.quantity,
      ),
    )
        .toList();

    final total = orderProducts.fold(0, (sum, p) => sum + p.subtotal);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          products: orderProducts,
          totalAmount: total,
        ),
      ),
    ).then((_) {
      // Optional: Remove selected items after successful order placement
      setState(() {
        cartManager.items.removeWhere((item) => item.isSelected);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = cartManager.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CartNavBar(),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return CartItemCard(
            product: item.product,
            isSelected: item.isSelected,
            quantity: item.quantity,
            onToggleSelect: () {
              setState(() {
                item.isSelected = !item.isSelected;
              });
            },
            onIncrement: () {
              setState(() {
                item.quantity++;
              });
            },
            onDecrement: () {
              if (item.quantity > 1) {
                setState(() {
                  item.quantity--;
                });
              }
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailPage(product: item.product),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? CartBottomBar(
        allSelected: allSelected,
        onToggleAll: toggleAll,
        total: calculateTotal(),
        onCheckout: () => _goToCheckout(context), // ✅ Redirect to CheckoutPage
      )
          : null,
    );
  }
}
