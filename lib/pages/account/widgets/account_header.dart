import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountHeader extends StatefulWidget {
  const AccountHeader({super.key});

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  File? imageFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
              child: imageFile == null
                  ? const Icon(Icons.person, size: 45)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: pickImage,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Hi, Group1",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text("Group1@email.com", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
