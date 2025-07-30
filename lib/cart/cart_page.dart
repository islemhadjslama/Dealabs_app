import 'package:flutter/material.dart';
import 'package:newapp/cart/widgets/cart_bottom_bar.dart';
import 'package:newapp/cart/widgets/cart_item_card.dart';
import 'package:newapp/cart/widgets/cart_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../product/product_detail_page.dart';
import '../checkout/checkout_screen.dart';
import '../models/cart_item.dart';
import '../models/order_product.dart';
import '../shared/managers/cart_manager.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  int calculateTotal(List<CartItem> items) {
    return items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.product.discountedPrice * item.quantity);
  }

  bool allSelected(List<CartItem> items) =>
      items.isNotEmpty && items.every((item) => item.isSelected);

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final cartItems = cartManager.items;

    void toggleAll() {
      final newValue = !allSelected(cartItems);
      cartManager.toggleAllSelection(newValue);
    }

    void goToCheckout() {
      final selectedItems = cartItems.where((item) => item.isSelected).toList();

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
        cartManager.removeSelectedItems();
      });
    }

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
            onToggleSelect: () => cartManager.toggleItemSelection(item.product),
            onIncrement: () => cartManager.incrementQuantity(item.product),
            onDecrement: () => cartManager.decrementQuantity(item.product),
            onDelete: () => cartManager.removeProduct(item.product),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: item.product),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? CartBottomBar(
        allSelected: allSelected(cartItems),
        onToggleAll: toggleAll,
        total: calculateTotal(cartItems),
        onCheckout: goToCheckout,
      )
          : null,
    );
  }
}
