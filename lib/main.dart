import 'package:flutter/material.dart';
import 'package:newapp/database/db_helper.dart';
import 'package:newapp/auth/auth_screen.dart';
import 'package:newapp/shared/main_screen.dart';
import 'package:newapp/services/auth_service.dart';
import 'package:newapp/shared/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Create DB if it doesn’t exist
  await dbHelper.printDatabaseInfo(); // Debug info

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loobus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const InitialScreen(),
    );
  }
}

// A simple wrapper to decide where to go first
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isLoading = true;
  Widget _startScreen = const WelcomeScreen();

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    final user = await AuthService().currentUser();
    setState(() {
      _startScreen = user != null ? const MainScreen() : const WelcomeScreen();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    )
        : _startScreen;
  }
}
