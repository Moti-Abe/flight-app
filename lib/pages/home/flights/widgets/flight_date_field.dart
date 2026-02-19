import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<DateTime>? onDatePicked;

  const FlightDateField({
    super.key,
    required this.label,
    required this.controller,
    this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            controller.text = DateFormat('EEE, MMM d').format(picked);
            onDatePicked?.call(picked);
          }
        },
        validator: (v) => v!.isEmpty ? "Select date" : null,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
