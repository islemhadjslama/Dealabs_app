import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../auth/widgets/app_logo.dart';
import 'widgets/sign_up_form.dart';
import 'widgets/register_button.dart';
import '../shared/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final User user = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${user.name}! Registration successful.')),
      );

      // Navigate to MainScreen after registration
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(),

              const SizedBox(height: 48),

              // SignUp Form
              SignUpForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                addressController: _addressController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                isPasswordVisible: _isPasswordVisible,
                isConfirmPasswordVisible: _isConfirmPasswordVisible,
                onPasswordVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                onConfirmPasswordVisibilityToggle: () {
                  setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
              ),
              const SizedBox(height: 40),

              // Register button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RegisterButton(onPressed: _register),
            ],
          ),
        ),
      ),
    );
  }
}


