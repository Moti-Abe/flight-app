import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'find_booking_page.dart';
import 'trips_controller.dart';
import 'widgets/booking_lookup_card.dart';
import 'widgets/plan_trip_sheet.dart';
import 'widgets/trip_card.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  void _showPlanTripDialog(BuildContext context, TripsController controller) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return PlanTripSheet(
          onSave: (name, description) {
            controller.addTrip(name: name, description: description);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TripsController controller = Get.find<TripsController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Trip Planner",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add, color: Color(0xFF2B6EF3)),
                  label: const Text(
                    "Plan a trip",
                    style: TextStyle(color: Color(0xFF2B6EF3)),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFF2B6EF3), width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () => _showPlanTripDialog(context, controller),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              "Saved",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: controller.trips.map((trip) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: TripCard(
                    title: trip.name,
                    savesLabel: trip.savesLabel,
                    onInvite: () => Get.snackbar("Invite", "Invite feature coming soon"),
                  ),
                );
              }).toList(),
            )),
            BookingLookupCard(
              onTap: () => Get.to(() => FindYourBookingPage()),
            ),
          ],
        ),
      ),
    );
  }
}