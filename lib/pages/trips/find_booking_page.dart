import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindYourBookingPage extends StatelessWidget {
  FindYourBookingPage({super.key});

  final TextEditingController itineraryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Find your booking"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const Text(
              "Enter your itinerary number",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            const Text(
              "Your itinerary number was emailed to you.\nAsterisk \"*\" indicates a required field",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: itineraryController,
              decoration: const InputDecoration(
                labelText: "Itinerary number *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot your itinerary number?"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.snackbar("Search", "Demo lookup not connected yet");
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
              child: const Text("Continue"),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Get.snackbar("Alternate email", "Demo flow not connected yet");
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E4EA)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Find a booking you made using a different email address",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 18)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
