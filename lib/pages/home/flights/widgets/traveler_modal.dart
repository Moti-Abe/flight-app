import 'package:flutter/material.dart';

class TravelerModal extends StatefulWidget {
  final int initialAdults;
  final String initialCabin;
  const TravelerModal({
    super.key,
    required this.initialAdults,
    required this.initialCabin,
  });

  @override
  State<TravelerModal> createState() => _TravelerModalState();
}

class _TravelerModalState extends State<TravelerModal> {
  late int adults;
  late String cabin;

  List<int?> childrenAges = [];
  List<int?> infantsInSeatAges = [];
  List<int?> infantsOnLapAges = [];

  final int maxTravelers = 6;

  @override
  void initState() {
    super.initState();
    adults = widget.initialAdults;
    cabin = widget.initialCabin;
  }

  int get totalTravelers =>
      adults +
      childrenAges.length +
      infantsInSeatAges.length +
      infantsOnLapAges.length;

  void _addTraveler(List list) {
    if (totalTravelers < maxTravelers) {
      setState(() {
        list.add(null);
      });
    }
  }

  void _removeTraveler(List list) {
    if (list.isNotEmpty) {
      setState(() {
        list.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Travelers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildCounterRow(
              "Adults",
              adults,
              onDecrement: () => setState(() => adults > 1 ? adults-- : 1),
              onIncrement: () => setState(
                () => totalTravelers < maxTravelers ? adults++ : null,
              ),
              isMax: totalTravelers >= maxTravelers,
            ),

            _buildCounterRow(
              "Children (2-17)",
              childrenAges.length,
              onDecrement: () => _removeTraveler(childrenAges),
              onIncrement: () => _addTraveler(childrenAges),
              isMax: totalTravelers >= maxTravelers,
            ),
            ...childrenAges.asMap().entries.map(
              (entry) => _buildAgeDropdown(
                label: "Child ${entry.key + 1} age",
                items: List.generate(16, (i) => i + 2),
                value: entry.value,
                onChanged: (val) =>
                    setState(() => childrenAges[entry.key] = val),
              ),
            ),

            _buildCounterRow(
              "Infants in seat (< 2)",
              infantsInSeatAges.length,
              onDecrement: () => _removeTraveler(infantsInSeatAges),
              onIncrement: () => _addTraveler(infantsInSeatAges),
              isMax: totalTravelers >= maxTravelers,
            ),
            ...infantsInSeatAges.asMap().entries.map(
              (entry) => _buildAgeDropdown(
                label: "Infant ${entry.key + 1} age",
                items: [0, 1],
                value: entry.value,
                onChanged: (val) =>
                    setState(() => infantsInSeatAges[entry.key] = val),
              ),
            ),

            _buildCounterRow(
              "Infants on lap (< 2)",
              infantsOnLapAges.length,
              onDecrement: () => _removeTraveler(infantsOnLapAges),
              onIncrement: () => _addTraveler(infantsOnLapAges),
              isMax: totalTravelers >= maxTravelers,
            ),
            ...infantsOnLapAges.asMap().entries.map(
              (entry) => _buildAgeDropdown(
                label: "Infant ${entry.key + 1} age",
                items: [0, 1],
                value: entry.value,
                onChanged: (val) =>
                    setState(() => infantsOnLapAges[entry.key] = val),
              ),
            ),

            const Divider(height: 40),
            const Text(
              "Cabin Class",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              initialValue: cabin,
              items: [
                "Economy",
                "Premium",
                "Business",
                "First",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => cabin = val!),
            ),

            const SizedBox(height: 20),
            if (totalTravelers >= maxTravelers)
              const Text(
                "Max 6 travelers per booking.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (childrenAges.contains(null) ||
                      infantsInSeatAges.contains(null) ||
                      infantsOnLapAges.contains(null)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please select ages for all children/infants",
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'adults': totalTravelers,
                    'cabin': cabin,
                  });
                },
                child: const Text("Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow(
    String title,
    int count, {
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required bool isMax,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text("$count"),
              IconButton(
                onPressed: isMax ? null : onIncrement,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: isMax ? Colors.grey : Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgeDropdown({
    required String label,
    required List<int> items,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 20),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
        items: items
            .map(
              (age) =>
                  DropdownMenuItem(value: age, child: Text("$age years old")),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
