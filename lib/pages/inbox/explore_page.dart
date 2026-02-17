import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Explore"),
          backgroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            "Explore destinations and interests here.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
}
