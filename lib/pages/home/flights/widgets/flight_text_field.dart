import 'package:flutter/material.dart';

class FlightTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onTap;

  const FlightTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true, // Crucial: prevents keyboard, triggers search page
        onTap: onTap,
        validator: (v) => v!.isEmpty ? "Select $label" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
