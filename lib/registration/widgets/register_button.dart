import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const RegisterButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722), // Orange, like your login button
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Sign up',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
