import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/managers/user_manager.dart';

class ProfileInfoForm extends StatefulWidget {
  const ProfileInfoForm({super.key});

  @override
  State<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends State<ProfileInfoForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  bool isEditing = false;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      final user = context.read<UserManager>().user;
      nameController = TextEditingController(text: user.name);
      emailController = TextEditingController(text: user.email);
      phoneController = TextEditingController(text: user.phone);
      addressController = TextEditingController(text: user.address);
      initialized = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void toggleEdit() => setState(() => isEditing = !isEditing);

  void saveChanges() {
    final userManager = context.read<UserManager>();
    userManager.updateUser(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
    );
    toggleEdit();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated')));
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
          borderSide:
          const BorderSide(color: Color(0xFFFF5722), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (context, userManager, _) {
        if (!isEditing) {
          final user = userManager.user;
          nameController.text = user.name;
          emailController.text = user.email;
          phoneController.text = user.phone;
          addressController.text = user.address;
        }

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
                foregroundColor: Colors.white, // ✅ Makes "Edit" & "Save" white
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: isEditing ? saveChanges : toggleEdit,
              child: Text(isEditing ? 'Save' : 'Edit'),
            ),

          ],
        );
      },
    );
  }
}
