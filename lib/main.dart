import 'package:flutter/material.dart';
import 'package:newapp/database/db_helper.dart';
import 'package:newapp/auth/auth_screen.dart';
import 'package:newapp/shared/main_screen.dart';
import 'package:newapp/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Create DB if it doesn’t exist
  await dbHelper.printDatabaseInfo(); // Debug info

  // Check if user is already logged in using AuthService
  final user = await AuthService().currentUser();

  runApp(MyApp(initialScreen: user == null ? const AuthScreen() : MainScreen()));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dealabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: initialScreen,
    );
  }
}
