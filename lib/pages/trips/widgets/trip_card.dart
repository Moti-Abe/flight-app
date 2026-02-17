import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String title;
  final String savesLabel;
  final VoidCallback onInvite;

  const TripCard({
    super.key,
    required this.title,
    required this.savesLabel,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 140,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8A8F98), Color(0xFF6F7580)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: -10,
              top: 10,
              child: Opacity(
                opacity: 0.12,
                child: Icon(Icons.flight_takeoff, size: 90, color: Colors.white),
              ),
            ),
            const Positioned(
              right: -6,
              bottom: -10,
              child: Opacity(
                opacity: 0.12,
                child: Icon(Icons.location_on, size: 90, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Color(0xFFFF5C5C), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        savesLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF565C68),
                  shape: const StadiumBorder(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: onInvite,
                icon: const Icon(Icons.group_outlined, size: 18),
                label: const Text("Invite"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
