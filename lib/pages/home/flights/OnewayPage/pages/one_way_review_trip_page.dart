import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/one_way_models.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_bottom_bar.dart';
import 'one_way_seat_selection_page.dart';

/// Page 4: Review your trip — flight details, fare, and price breakdown.
class OneWayReviewTripPage extends StatelessWidget {
  final OneWayBooking booking;

  const OneWayReviewTripPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final flight = booking.flight;
    final fare = booking.fare;
    final farePrice = flight.price * fare.priceMultiplier;
    final routeSubtitle =
        '${flight.fromCity} to ${flight.toCity.split(' (').first}';

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: BookingAppBar(title: 'Review your trip', subtitle: routeSubtitle),
      body: Column(
        children: [
          const BookingStepIndicator(currentStep: 0),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _buildFlightCard(context),
                const SizedBox(height: 16),
                _buildFareCard(context),
                const SizedBox(height: 16),
                _buildPriceSummary(context, farePrice),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BookingBottomBar(
        tripTotal: farePrice,
        buttonLabel: 'Next: Seats',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OneWaySeatSelectionPage(booking: booking),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlightCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final flight = booking.flight;
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
            '$fromName to $toName',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${flight.departTime} - ${flight.arriveTime} (${flight.duration}, ${flight.stops})',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
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
                      fontSize: 11,
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
          const SizedBox(height: 12),
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
    final fare = booking.fare;

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
            'Your fare: ${fare.name}',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          ...fare.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildFeatureRow(context, f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, FareFeature feature) {
    final colors = Theme.of(context).colorScheme;
    IconData icon;
    Color iconColor;
    switch (feature.type) {
      case FareFeatureType.included:
        icon = Icons.check_circle;
        iconColor = const Color(0xFF2E7D32);
        break;
      case FareFeatureType.paid:
        icon = Icons.attach_money;
        iconColor = const Color(0xFF1565C0);
        break;
      case FareFeatureType.notIncluded:
        icon = Icons.close;
        iconColor = colors.onSurface.withValues(alpha: 0.5);
        break;
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

  Widget _buildPriceSummary(BuildContext context, double farePrice) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final formatter = NumberFormat.simpleCurrency(name: 'USD');
    final taxes = farePrice * 0.08;
    final total = farePrice + taxes;

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
          _priceRow(context, 'Flight', formatter.format(farePrice)),
          const SizedBox(height: 8),
          _priceRow(context, 'Taxes & fees', formatter.format(taxes)),
          const Divider(height: 20),
          _priceRow(context, 'Total', formatter.format(total), bold: true),
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
