import 'package:flutter/material.dart';

/// Breadcrumb-style step indicator for round-trip booking flow.
/// Steps: Your flights > Seats > Bags > Checkout
class RtStepIndicator extends StatelessWidget {
  final int currentStep; // 0=flights, 1=seats, 2=bags, 3=checkout

  const RtStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const steps = ['Your flights', 'Seats', 'Bags', 'Checkout'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF2A3141) : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Text(
              steps[i],
              style: TextStyle(
                color: i == currentStep
                    ? colors.onSurface
                    : colors.onSurface.withValues(alpha: 0.45),
                fontSize: 13,
                fontWeight: i == currentStep
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            if (i < steps.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: colors.onSurface.withValues(alpha: 0.35),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
