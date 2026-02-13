import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Email")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "New email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Get.snackbar("Success", "Email updated");
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
