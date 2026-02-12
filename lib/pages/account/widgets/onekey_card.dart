import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ceredits.dart';

class OneKeyCard extends StatelessWidget {
  const OneKeyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "OneKeyCash",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Text(
                  "\$0.00",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 6),
                Icon(Icons.info_outline, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Rewards activity"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(() => Ceredits()),
            ),
          ],
        ),
      ),
    );
  }
}
