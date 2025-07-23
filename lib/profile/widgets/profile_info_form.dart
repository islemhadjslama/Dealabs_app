
import 'package:flutter/material.dart';

import '../../models/user.dart';

class ProfileInfoForm extends StatefulWidget {
  final User user;

  const ProfileInfoForm({super.key, required this.user});

  @override
  State<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends State<ProfileInfoForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void saveChanges() {
    // Save to DB or state management
    toggleEdit();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildField('Name', nameController),
        const SizedBox(height: 10),
        buildField('Email', emailController),
        const SizedBox(height: 10),
        buildField('Phone', phoneController),
        const SizedBox(height: 10),
        buildField('Address', addressController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isEditing ? saveChanges : toggleEdit,
          child: Text(isEditing ? 'Save' : 'Edit'),
        ),
      ],
    );
  }
}
