import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;

  const SignUpForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
  }) : super(key: key);

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A1A1A)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          const Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            decoration: _inputDecoration(hint: 'Your full name'),
            validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),

          // Email
          const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(hint: 'username@example.com'),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone
          const Text('Phone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(hint: 'Optional'),
          ),
          const SizedBox(height: 16),

          // Address
          const Text('Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: addressController,
            decoration: _inputDecoration(hint: 'Optional'),
          ),
          const SizedBox(height: 16),

          // Password
          const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: _inputDecoration(hint: '••••••••').copyWith(
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey[500]),
                onPressed: onPasswordVisibilityToggle,
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter your password';
              if (val.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password
          const Text('Confirm Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            decoration: _inputDecoration(hint: '••••••••').copyWith(
              suffixIcon: IconButton(
                icon: Icon(isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey[500]),
                onPressed: onConfirmPasswordVisibilityToggle,
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Confirm your password';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
