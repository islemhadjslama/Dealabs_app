import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/managers/user_manager.dart';
import 'widgets/profile_image_widget.dart';
import 'widgets/profile_info_form.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserManager>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileImageWidget(imagePath: user.image),
            const SizedBox(height: 20),
            const ProfileInfoForm(),
          ],
        ),
      ),
    );
  }
}
