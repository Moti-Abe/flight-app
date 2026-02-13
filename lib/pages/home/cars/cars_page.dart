import 'package:expedia/pages/home/cars/car_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Rental')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car, size: 100, color: Colors.blueGrey),
            const SizedBox(height: 24),
            const Text(
              'Find your perfect rental car!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Get.to(() => CarSearchScreen());
              },
              child: const Text('Search Cars'),
            ),
          ],
        ),
      ),
    );
  }
}
