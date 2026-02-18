import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'multi_city_secure_booking_page.dart';

class MultiCityFlightDetailsPage extends StatelessWidget {
  final MultiCitySelection selection;

  const MultiCityFlightDetailsPage({super.key, required this.selection});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark
        ? const Color(0xFF0B0F1A)
        : Colors.white;
    final flight1 = selection.flight1!;
    final flight2 = selection.flight2!;
    final flight3 = selection.flight3;
    final baseTotal = flight1.price + flight2.price + (flight3?.price ?? 0);
    final taxes = baseTotal * 0.08;
    final grandTotal = baseTotal + taxes;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        foregroundColor: colors.onSurface,
        title: const Text('Review your trip'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          _buildSegmentCard(context, 'Flight 1', flight1),
          const SizedBox(height: 16),
          _buildSegmentCard(context, 'Flight 2', flight2),
          if (flight3 != null) ...[
            const SizedBox(height: 16),
            _buildSegmentCard(context, 'Flight 3', flight3),
          ],
          const SizedBox(height: 18),
          _buildFareCard(context, flight1.cabin),
          const SizedBox(height: 18),
          _buildPriceSummary(context, baseTotal, taxes, grandTotal),
        ],
      ),
      bottomNavigationBar: _buildStickyButton(context, grandTotal),
    );
  }

  Widget _buildSegmentCard(
    BuildContext context,
    String title,
    MultiCityFlight flight,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${flight.fromCity} to ${flight.toCity}',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${flight.departTime} - ${flight.arriveTime} '
            '(${flight.duration}, ${flight.stops})',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${flight.airline} · ${flight.dateLabel}',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareCard(BuildContext context, String cabin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark
        ? const Color(0xFF111624)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your fare: Economy',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildBullet(context, 'Carry-on bag included'),
          _buildBullet(context, '2 checked bags included (50 lbs each)'),
          _buildBullet(context, 'Cancellation fee: USD 100'),
          _buildBullet(context, 'Changes not allowed'),
        ],
      ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    final textColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4ADE80), size: 16),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(
    BuildContext context,
    double base,
    double taxes,
    double total,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    final formatter = NumberFormat.simpleCurrency(name: 'USD');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip total',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatter.format(total),
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow(context, 'Flights', formatter.format(base)),
          _buildPriceRow(context, 'Taxes and fees', formatter.format(taxes)),
          const SizedBox(height: 10),
          _buildPriceRow(
            context,
            'Grand total',
            formatter.format(total),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyButton(BuildContext context, double total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final barColor = isDark
        ? const Color(0xFF0B0F1A)
        : colors.surface.withValues(alpha: 0.9);
    final borderColor = isDark
        ? const Color(0xFF1E2433)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    final formatter = NumberFormat.simpleCurrency(name: 'USD');
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Trip total',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  formatter.format(total),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7FB5FF),
              foregroundColor: isDark
                  ? const Color(0xFF0B0F1A)
                  : colors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiCitySecureBookingPage(
                    selection: selection,
                    total: total,
                  ),
                ),
              );
            },
            child: const Text('Next - Checkout'),
          ),
        ],
      ),
    );
  }
}
