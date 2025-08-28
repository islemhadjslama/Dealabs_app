import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfileImageWidget extends StatelessWidget {
  final User user;

  const ProfileImageWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: const Color(0xFFFF5722),
      backgroundImage: user.image != null && user.image!.isNotEmpty
          ? AssetImage(user.image!) as ImageProvider
          : const AssetImage("assets/images/default_avatar.png"),
    );
  }
}
