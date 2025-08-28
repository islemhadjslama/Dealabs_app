import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class ProfileInfoForm extends StatefulWidget {
  final User user;

  const ProfileInfoForm({super.key, required this.user});

  @override
  State<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends State<ProfileInfoForm> {
  final AuthService _authService = AuthService();

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
    setState(() => isEditing = !isEditing);
  }

  Future<void> saveChanges() async {
    try {
      await _authService.updateProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
      );
      setState(() => isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFFF5722)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF5722)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: isEditing ? saveChanges : toggleEdit,
          child: Text(isEditing ? 'Save' : 'Edit'),
        ),
      ],
    );
  }
}

