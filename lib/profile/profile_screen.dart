import 'package:flutter/material.dart';
import 'package:newapp/profile/widgets/profile_image_widget.dart';
import 'package:newapp/profile/widgets/profile_info_form.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../shared/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.currentUser();
    setState(() {
      _currentUser = user;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // flat appbar
        leading: null, // remove the back arrow
        automaticallyImplyLeading: false, // also ensure no default leading
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await _authService.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---- Profile picture ----
            ProfileImageWidget(user: _currentUser!),

            const SizedBox(height: 20),

            // ---- Profile form ----
            ProfileInfoForm(user: _currentUser!),
          ],
        ),
      ),
    );
  }
}
