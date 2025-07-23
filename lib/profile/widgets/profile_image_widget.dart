
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imagePath;

  const ProfileImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60,
      backgroundImage: AssetImage(imagePath),
    );
  }
}
