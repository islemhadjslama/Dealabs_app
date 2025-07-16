import 'package:flutter/material.dart';
import 'package:newapp/cart/widgets/cart_bottom_bar.dart';
import 'package:newapp/cart/widgets/cart_item_card.dart';
import 'package:newapp/cart/widgets/cart_nav_bar.dart';
import '../models/product.dart';
import '../product/product_detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Product> cartProducts;
  late List<bool> isSelected;
  late List<int> quantities;

  @override
  void initState() {
    super.initState();

    cartProducts = [
      Product(
        id: '1',
        name: 'Nike Air Max 270',
        description: 'Comfortable and stylish sneakers for everyday wear.',
        originalPrice: 2200000,
        discountedPrice: 1790000,
        discountPercentage: 19,
        images: [
          'assets/products/nike1.webp',
          'assets/products/nike2.webp',
        ],
        rating: 4.6,
        reviews: 1425,
        brand: 'Nike',
        category: 'Shoes',
        sellerName: 'Nike Official Store',
        sellerLocation: 'Jakarta',
        inStock: true,
        freeShipping: true,
        specifications: [
          'Breathable mesh upper',
          'Air Max heel unit',
          'Rubber outsole',
        ],
        tags: ['men', 'running', '2024', 'new'],
      ),
      Product(
        id: '2',
        name: 'Adidas Ultraboost 21',
        description: 'High-performance running shoes with responsive cushioning.',
        originalPrice: 2500000,
        discountedPrice: 1990000,
        discountPercentage: 20,
        images: [
          'assets/products/adidas2.jpg',
          'assets/products/adidas2.webp',
        ],
        rating: 4.8,
        reviews: 990,
        brand: 'Adidas',
        category: 'Shoes',
        sellerName: 'Adidas Store',
        sellerLocation: 'Bandung',
        inStock: true,
        freeShipping: false,
        specifications: [
          'Primeknit+ textile upper',
          'Boost midsole',
          'Stretchweb outsole',
        ],
        tags: ['running', 'boost', 'adidas'],
      ),
    ];

    isSelected = List.generate(cartProducts.length, (_) => false);
    quantities = List.generate(cartProducts.length, (_) => 1);
  }

  int calculateTotal() {
    int total = 0;
    for (int i = 0; i < cartProducts.length; i++) {
      if (isSelected[i]) {
        total += cartProducts[i].discountedPrice * quantities[i];
      }
    }
    return total;
  }

  bool get allSelected => isSelected.every((selected) => selected);

  void toggleAll() {
    final newValue = !allSelected;
    setState(() {
      isSelected = List.generate(cartProducts.length, (_) => newValue);
    });
  }

  void onCheckout() {
    final selectedItems = cartProducts
        .asMap()
        .entries
        .where((entry) => isSelected[entry.key])
        .map((entry) => entry.value)
        .toList();
    // TODO: implement checkout logic here
    print("Proceeding to checkout with ${selectedItems.length} items");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CartNavBar(),
      body: ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          final product = cartProducts[index];
          return CartItemCard(
            product: product,
            isSelected: isSelected[index],
            quantity: quantities[index],
            onToggleSelect: () {
              setState(() {
                isSelected[index] = !isSelected[index];
              });
            },
            onIncrement: () {
              setState(() {
                quantities[index]++;
              });
            },
            onDecrement: () {
              if (quantities[index] > 1) {
                setState(() {
                  quantities[index]--;
                });
              }
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CartBottomBar(
        allSelected: allSelected,
        onToggleAll: toggleAll,
        total: calculateTotal(),
        onCheckout: onCheckout,
      ),
    );
  }
}

