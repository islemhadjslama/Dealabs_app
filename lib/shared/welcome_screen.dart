import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';
import '../registration/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White behind rounded corners
      body: Column(
        children: [
          // Top illustration section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4A4A4A),
                    Color(0xFF2A2A2A),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Floating decorative circles
                  Positioned(
                    top: 60,
                    right: 40,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 30,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    right: 80,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Main illustration image filling space
                  Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://img.freepik.com/vecteurs-premium/homme-recoit-produit-commande_11197-510.jpg?semt=ais_hybrid&w=740&q=80',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom white section with rounded corners
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),

                    // Titles
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Dealabs',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5722),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Buttons side by side
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5722),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AuthScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1A1A1A),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
