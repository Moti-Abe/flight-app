import 'package:expedia/pages/account/profile_page.dart';
import 'package:expedia/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reviews")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Get.to(() => ProfilePage());
              },
              child: Text("My Account", style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 10),
            Text(
              "Your first review awaits..",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.to(() => HomePage());
              },
              child: Text(
                "Book your next adventure",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
