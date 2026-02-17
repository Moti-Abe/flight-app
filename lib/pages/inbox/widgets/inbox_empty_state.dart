import 'package:flutter/material.dart';

class InboxEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? primaryCta;
  final VoidCallback? onPrimary;

  const InboxEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.primaryCta,
    this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      children: [
        Align(
          alignment: Alignment.center,
          child: Icon(icon, size: 90, color: const Color(0xFF6FA0D9)),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF1E1E2D),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14.5, color: Color(0xFF6C6C80)),
        ),
        if (primaryCta != null) ...[
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPrimary,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color(0xFF2B6EF3),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(primaryCta!, style: const TextStyle(fontSize: 15.5)),
            ),
          ),
        ],
      ],
    );
  }
}
