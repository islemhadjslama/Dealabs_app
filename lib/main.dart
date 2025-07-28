import 'package:flutter/material.dart';
import 'package:newapp/shared/cart_manager.dart';
import 'package:newapp/shared/order_manager.dart';
import 'package:provider/provider.dart';
import 'package:newapp/data/demo_products.dart';
import 'package:newapp/home/home_screen.dart';
import 'package:newapp/shared/main_screen.dart';
import 'package:newapp/wishlist/wishlist_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProvider(create: (_) => OrderManager()),
      ],
      child: const MyApp(),
    ),
  );
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
      home: MainScreen(),
    );
  }
}
