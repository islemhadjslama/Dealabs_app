import 'package:flutter/material.dart';

class CartNavBar extends StatefulWidget implements PreferredSizeWidget {
  const CartNavBar({super.key});

  @override
  State<CartNavBar> createState() => _CartNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CartNavBarState extends State<CartNavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      title: const Text(
        'My cart',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}



