import 'package:flutter/material.dart';
import 'package:newapp/cart/widgets/cart_bottom_bar.dart';
import 'package:newapp/cart/widgets/cart_item_card.dart';
import 'package:newapp/cart/widgets/cart_nav_bar.dart';
import '../../product/product_detail_page.dart';
import '../checkout/checkout_screen.dart';
import '../models/cart_item.dart';
import '../models/order_product.dart';
import '../services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Future<List<CartItem>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _cartFuture = _cartService.getCartItems();
    });
  }

  bool _allSelected(List<CartItem> items) =>
      items.isNotEmpty && items.every((item) => item.isSelected);

  Future<void> _toggleAll(bool newValue) async {
    await _cartService.toggleAllSelection(newValue);
    _refresh();
  }

  Future<void> _goToCheckout(List<CartItem> cartItems) async {
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

    // Navigate to CheckoutPage and wait for result
    final orderPlaced = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          products: orderProducts,
          totalAmount: total,
        ),
      ),
    );

    // If the user placed an order, refresh the cart and optionally notify TransactionScreen
    if (orderPlaced == true) {
      // Remove selected items from cart
      for (var item in selectedItems) {
        await _cartService.removeFromCart(item.product.id);
      }
      _refresh();

      // Optionally, if TransactionScreen is already in the widget tree, you can trigger a refresh
      // For example, using a global key or state management solution (Provider/SetState)
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CartNavBar(),
      body: FutureBuilder<List<CartItem>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!;
          if (cartItems.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return CartItemCard(
                product: item.product,
                isSelected: item.isSelected,
                quantity: item.quantity,
                onToggleSelect: () async {
                  await _cartService.toggleSelection(item.product.id);
                  _refresh();
                },
                onIncrement: () async {
                  await _cartService.updateQuantity(item.product.id, item.quantity + 1);
                  _refresh();
                },
                onDecrement: () async {
                  await _cartService.updateQuantity(item.product.id, item.quantity - 1);
                  _refresh();
                },
                onDelete: () async {
                  await _cartService.removeFromCart(item.product.id);
                  _refresh();
                },
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
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<List<CartItem>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
          final cartItems = snapshot.data!;
          final total = cartItems
              .where((i) => i.isSelected)
              .fold(0, (sum, i) => sum + i.product.discountedPrice * i.quantity);

          return CartBottomBar(
            allSelected: _allSelected(cartItems),
            onToggleAll: () => _toggleAll(!_allSelected(cartItems)),
            total: total,
            onCheckout: () => _goToCheckout(cartItems),
          );
        },
      ),
    );
  }
}
