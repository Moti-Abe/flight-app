import 'package:flutter/material.dart';

class PlanTripSheet extends StatefulWidget {
  final void Function(String name, String description) onSave;

  const PlanTripSheet({super.key, required this.onSave});

  @override
  State<PlanTripSheet> createState() => _PlanTripSheetState();
}

class _PlanTripSheetState extends State<PlanTripSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    widget.onSave(_nameController.text.trim(), _descriptionController.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Plan a new trip",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Track things you love and plan your whole trip",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Trip name *",
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? "Trip name required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
