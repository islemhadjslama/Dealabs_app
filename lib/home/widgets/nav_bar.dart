import 'package:flutter/material.dart';

import '../../cart/cart_page.dart'; // Make sure this path is correct

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ⬅️ push ends apart
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/applogo.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Dealabs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
