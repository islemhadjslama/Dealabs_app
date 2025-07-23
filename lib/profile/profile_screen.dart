import 'package:flutter/material.dart';
import 'package:newapp/profile/widgets/profile_image_widget.dart';
import 'package:newapp/profile/widgets/profile_info_form.dart';
import '../data/demo_user.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = demoUser;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileImageWidget(imagePath: user.image), // ⬅️ image widget
            const SizedBox(height: 20),
            ProfileInfoForm(user: user), // ⬅️ editable info form
          ],
        ),
      ),
    );
  }
}
