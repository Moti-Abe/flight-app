import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Old password",
                border: OutlineInputBorder(),
              ),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Get.snackbar("Success", "Password changed");
                Get.back();
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
