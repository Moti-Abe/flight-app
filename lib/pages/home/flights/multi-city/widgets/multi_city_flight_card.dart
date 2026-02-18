import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class MultiCityFlightCard extends StatelessWidget {
  final MultiCityFlight flight;
  final VoidCallback onSelect;

  const MultiCityFlightCard({
    super.key,
    required this.flight,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final textColor = colors.onSurface;
    final mutedColor = colors.onSurface.withValues(alpha: 0.6);

    final priceText = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    ).format(flight.price);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Airline logo + Times + Price ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Airline icon
                    _buildAirlineIcon(context),
                    const SizedBox(width: 10),
                    // Times column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Departure / arrival row
                          Row(
                            children: [
                              Text(
                                flight.departTime,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Dot - line - dot connector
                              _buildTimeConnector(isDark),
                              const SizedBox(width: 6),
                            ],
                          ),
                          Text(
                            flight.arriveTime,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (flight.seatsLeft != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              '${flight.seatsLeft} left at',
                              style: const TextStyle(
                                color: Color(0xFFE53935),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        Text(
                          priceText,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Multi-city trip per traveler',
                          style: TextStyle(color: mutedColor, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // ── Route ──
                Text(
                  '${flight.fromCity} - ${flight.toCity}',
                  style: TextStyle(color: mutedColor, fontSize: 13),
                ),
                const SizedBox(height: 4),
                // ── Airline line (+ operated by) ──
                Text(
                  flight.operatedBy != null
                      ? '${flight.airline} operated by ${flight.operatedBy}'
                      : flight.airline,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // ── Duration & stops ──
                Row(
                  children: [
                    Text(
                      '${flight.duration} · ${flight.stops}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // ── Layover info ──
                if (flight.layoverInfo != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    flight.layoverInfo!,
                    style: TextStyle(color: mutedColor, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 8),
                // ── Flight details link ──
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onSelect,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAirlineIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    // Simulated airline logo circle
    final bgColor = isDark
        ? const Color(0xFF1A2340)
        : colors.surfaceContainerHighest;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          flight.airline.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeConnector(bool isDark) {
    final lineColor = isDark ? const Color(0xFF4A5568) : Colors.grey.shade400;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: lineColor, width: 1.5),
          ),
        ),
        Container(width: 24, height: 1.5, color: lineColor),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: lineColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
