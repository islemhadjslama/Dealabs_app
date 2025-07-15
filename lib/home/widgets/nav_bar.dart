import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              'assets/applogo.png', // Make sure this image exists in assets
              width: 40,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Dealabs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // ✅ Title is now black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
