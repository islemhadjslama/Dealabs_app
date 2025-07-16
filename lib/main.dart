import 'package:flutter/material.dart';
import 'package:newapp/auth/auth_screen.dart';
import 'package:newapp/auth/widgets/app_logo.dart';
import 'package:newapp/cart/cart_page.dart';
import 'package:newapp/home/home_screen.dart';
import 'package:newapp/home/widgets/advertizing_card.dart';
import 'package:newapp/home/widgets/bottom_navbar.dart';
import 'package:newapp/home/widgets/category_slider.dart';
import 'package:newapp/home/widgets/nav_bar.dart';
import 'package:newapp/shared/product_cart.dart';
import 'package:newapp/product/product_detail_page.dart';
import 'package:newapp/search/search_page.dart';
import 'package:newapp/search/widgets/popular_search_section.dart';

import 'models/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
