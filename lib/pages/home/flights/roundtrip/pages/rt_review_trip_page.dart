import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/round_trip_models.dart';
import '../widgets/rt_step_indicator.dart';
import '../widgets/rt_bottom_bar.dart';
import 'rt_seat_selection_page.dart';

/// Page 5: Review your trip — shows both flight cards, fare, and price breakdown.
class RtReviewTripPage extends StatelessWidget {
  final RoundTripBooking booking;

  const RtReviewTripPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final dep = booking.departureFlight;
    final ret = booking.returnFlight;
    final fare = booking.fare;
    final departFare = dep.price * fare.priceMultiplier;
    final returnFare = ret.price * fare.priceMultiplier;
    final totalFare = departFare + returnFare;

    final fromName = dep.fromCity.split(' (').first;
    final toName = dep.toCity.split(' (').first;
    final routeSubtitle = '$fromName to $toName';

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0B0F1A) : Colors.white,
        elevation: 0,
        foregroundColor: colors.onSurface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review your trip',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              routeSubtitle,
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const RtStepIndicator(currentStep: 0),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _buildFlightCard(context, 'Departing flight', dep),
                const SizedBox(height: 12),
                _buildFlightCard(context, 'Return flight', ret),
                const SizedBox(height: 16),
                _buildFareCard(context),
                const SizedBox(height: 16),
                _buildPriceSummary(context, departFare, returnFare, totalFare),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: RtBottomBar(
        tripTotal: totalFare,
        buttonLabel: 'Next: Seats',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RtSeatSelectionPage(booking: booking),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlightCard(
    BuildContext context,
    String label,
    RoundTripFlight flight,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final fromName = flight.fromCity.split(' (').first;
    final toName = flight.toCity.split(' (').first;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$fromName to $toName',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${flight.departTime} – ${flight.arriveTime} (${flight.duration}, ${flight.stops})',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2340)
                      : const Color(0xFFE8EAF6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    flight.airline.substring(0, 1),
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF7FB5FF)
                          : const Color(0xFF1565C0),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${flight.airline} · ${flight.dateLabel}',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2433) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Average CO₂',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Flight details',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF7FB5FF)
                        : const Color(0xFF1565C0),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Change flight',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF7FB5FF)
                        : const Color(0xFF1565C0),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your fare: ${booking.fare.name}',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          ...booking.fare.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildFeatureRow(context, f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, RtFareFeature feature) {
    final colors = Theme.of(context).colorScheme;
    IconData icon;
    Color iconColor;
    switch (feature.type) {
      case RtFareFeatureType.included:
        icon = Icons.check_circle;
        iconColor = const Color(0xFF2E7D32);
      case RtFareFeatureType.paid:
        icon = Icons.attach_money;
        iconColor = const Color(0xFF1565C0);
      case RtFareFeatureType.notIncluded:
        icon = Icons.close;
        iconColor = colors.onSurface.withValues(alpha: 0.5);
    }
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            feature.text,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(
    BuildContext context,
    double departFare,
    double returnFare,
    double totalFare,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final formatter = NumberFormat.simpleCurrency(name: 'USD');
    final taxes = totalFare * 0.08;
    final grandTotal = totalFare + taxes;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price breakdown',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _priceRow(context, 'Departing flight', formatter.format(departFare)),
          const SizedBox(height: 8),
          _priceRow(context, 'Return flight', formatter.format(returnFare)),
          const SizedBox(height: 8),
          _priceRow(context, 'Taxes & fees', formatter.format(taxes)),
          const Divider(height: 20),
          _priceRow(context, 'Total', formatter.format(grandTotal), bold: true),
        ],
      ),
    );
  }

  Widget _priceRow(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: bold ? 1.0 : 0.7),
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
