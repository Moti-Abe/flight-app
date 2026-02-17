import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/flight_controller.dart';

class FlightResultsPage extends StatelessWidget {
  FlightResultsPage({super.key});

  final FlightController controller = Get.find<FlightController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF003580), // Expedia Navy
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _buildExpediaAppBar(context),
      ),
      body: Column(
        children: [
          _buildDateRibbon(), // Horizontal Date & Price Week
          _buildFilterBar(), // Sort & Filter Button
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) => _buildFlightCard(index),
            ),
          ),
        ],
      ),
    );
  }

  // 1. APP BAR: Summary Header with Double Arrow
  Widget _buildExpediaAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(), // Navigates back to search to "edit"
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${controller.fromCity.value.text} to ${controller.toCity.value.text}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.double_arrow,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                  Text(
                    "${controller.dateRangeText.value} • ${controller.travelers.value} Traveler",
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // 2. DATE RIBBON: Week view with prices
  Widget _buildDateRibbon() {
    return Container(
      height: 70,
      color: const Color(0xFF003580),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          bool isSelected = index == 2; // Mock selection
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mar ${10 + index}",
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${340 + (index * 12)}",
                  style: TextStyle(
                    color: isSelected ? Colors.blue[800] : Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 3. FILTER BAR
  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "56 flights found",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          OutlinedButton.icon(
            onPressed: () {}, // Add your Sort/Filter Modal here
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text("Sort & Filter"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue[800],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. FLIGHT CARD: Expedia High-Density Layout
  Widget _buildFlightCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "10:30 AM - 1:45 PM",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${420 + index}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ethiopian Airlines",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const Text(
                "roundtrip",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              const Text("3h 15m (Nonstop)", style: TextStyle(fontSize: 13)),
              const Spacer(),
              Text(
                "Select",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.blue[800]),
            ],
          ),
        ],
      ),
    );
  }
}
