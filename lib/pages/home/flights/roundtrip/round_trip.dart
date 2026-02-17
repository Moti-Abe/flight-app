import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/flight_controller.dart';
import '../widgets/flight_text_field.dart';
import '../widgets/search_button.dart';
import '../widgets/traveler_modal.dart';
import '../widgets/city_search_screen.dart';

class RoundtripPage extends StatelessWidget {
  RoundtripPage({super.key});

  final FlightController control = Get.put(FlightController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  Obx(
                    () => FlightTextField(
                      label: "Leaving from",
                      icon: Icons.location_on,
                      controller: control.fromCity.value,
                      onTap: () => _openSearch("From"),
                    ),
                  ),
                  Obx(
                    () => FlightTextField(
                      label: "Going to",
                      icon: Icons.location_on,
                      controller: control.toCity.value,
                      onTap: () => _openSearch("To"),
                    ),
                  ),
                ],
              ),
              _buildSwapButton(),
            ],
          ),

          // Single Date Field
          _buildSelectionTile(
            icon: Icons.calendar_today,
            onTap: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              control.updateDateRange(range);
            },
            content: Obx(() => Text(control.dateRangeText.value)),
          ),

          // Traveler Selection
          const SizedBox(height: 12),
          _buildSelectionTile(
            icon: Icons.people_outline,
            onTap: _showTravelers,
            content: Obx(
              () => Text(
                "${control.travelers.value} Travelers, ${control.cabinClass.value}",
              ),
            ),
          ),
          Obx(
            () => CheckboxListTile(
              title: const Text(
                "Add a stay to bundle and save",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              value: control.addStay.value,
              onChanged: (val) => control.addStay.value = val!,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 20),
          SearchButton(onPressed: control.performSearch),
        ],
      ),
    );
  }


  void _openSearch(String type) async {
    final result = await Get.to(() => CitySearchScreen(title: "Select $type"));
    if (result != null) {
      if (type == "From") {
        control.fromCity.value.text = result;
      } else {
        control.toCity.value.text = result;
      }
    }
  }

  void _showTravelers() async {
    final result = await Get.bottomSheet(
      TravelerModal(
        initialAdults: control.travelers.value,
        initialCabin: control.cabinClass.value,
      ),
      backgroundColor: Colors.white,
    );
    if (result != null) {
      control.travelers.value = result['adults'];
      control.cabinClass.value = result['cabin'];
    }
  }

  Widget _buildSelectionTile({
    required IconData icon,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildSwapButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 12),
      child: GestureDetector(
        onTap: control.swapCities,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: const Icon(Icons.swap_vert, color: Colors.blue, size: 28),
        ),
      ),
    );
  }
}
