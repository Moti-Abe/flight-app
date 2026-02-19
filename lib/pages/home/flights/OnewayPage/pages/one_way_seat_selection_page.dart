import 'package:flutter/material.dart';
import '../models/one_way_models.dart';
import '../models/one_way_mock_data.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_bottom_bar.dart';
import 'one_way_bags_page.dart';

/// Page 5: Seat selection with visual seat map.
class OneWaySeatSelectionPage extends StatefulWidget {
  final OneWayBooking booking;

  const OneWaySeatSelectionPage({super.key, required this.booking});

  @override
  State<OneWaySeatSelectionPage> createState() =>
      _OneWaySeatSelectionPageState();
}

class _OneWaySeatSelectionPageState extends State<OneWaySeatSelectionPage> {
  late List<List<SeatInfo>> _seatMap;
  String? _selectedSeat;
  double _seatPrice = 0;

  @override
  void initState() {
    super.initState();
    _seatMap = generateSeatMap();
  }

  double get _tripTotal {
    final farePrice =
        widget.booking.flight.price * widget.booking.fare.priceMultiplier;
    return farePrice + _seatPrice;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final flight = widget.booking.flight;
    final routeSubtitle =
        '${flight.fromCity} to ${flight.toCity.split(' (').first}';

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: BookingAppBar(
        title: 'Choose your seats',
        subtitle: routeSubtitle,
      ),
      body: Column(
        children: [
          const BookingStepIndicator(currentStep: 1),
          // Segment pills
          _buildSegmentPills(context),
          // Traveler info
          _buildTravelerInfo(context),
          // Cabin label
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              flight.cabin,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Column headers
          _buildColumnHeaders(context),
          // Seat map
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  for (int rowIdx = 0; rowIdx < _seatMap.length; rowIdx++)
                    _buildSeatRow(context, rowIdx),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BookingBottomBar(
        tripTotal: _tripTotal,
        buttonLabel: 'Next: Bags',
        topLabel: 'Seats total',
        topAmount: _seatPrice,
        onPressed: () {
          final updatedBooking = widget.booking.copyWith(
            selectedSeat: _selectedSeat,
            seatPrice: _seatPrice,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OneWayBagsPage(booking: updatedBooking),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentPills(BuildContext context) {
    final flight = widget.booking.flight;
    final fromName = flight.fromCity.split(' (').first;
    final toName = flight.toCity.split(' (').first;

    // If flight has stops, show two segments
    final hasStop = flight.stops != 'Nonstop';
    String? layoverCity;
    if (hasStop && flight.layoverInfo != null) {
      final match = RegExp(r'in (\w+)').firstMatch(flight.layoverInfo!);
      layoverCity = match?.group(1);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _segmentPill(
            context,
            '$fromName – ${layoverCity ?? toName}',
            selected: true,
          ),
          if (hasStop && layoverCity != null) ...[
            const SizedBox(width: 8),
            _segmentPill(context, '$layoverCity – $toName', selected: false),
          ],
        ],
      ),
    );
  }

  Widget _segmentPill(
    BuildContext context,
    String label, {
    required bool selected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? (isDark ? const Color(0xFF1A2340) : const Color(0xFFE3F2FD))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? const Color(0xFF1565C0)
              : (isDark ? const Color(0xFF2A3141) : Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2340) : const Color(0xFFE8EAF6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.booking.flight.airline.substring(0, 1),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? const Color(0xFF7FB5FF)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            'Traveler 1',
            style: TextStyle(
              color: accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _selectedSeat != null ? 'Seat $_selectedSeat' : 'No seat selected',
            style: TextStyle(color: accentColor, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 120,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const SizedBox(width: 24), // row number space
          ...cols.map(
            (col) => Expanded(
              child: Center(
                child: Text(
                  col,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24), // row number space right
        ],
      ),
    );
  }

  Widget _buildSeatRow(BuildContext context, int rowIdx) {
    final colors = Theme.of(context).colorScheme;
    final row = _seatMap[rowIdx];
    final rowNumber = rowIdx + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      child: Row(
        children: [
          // Row number left
          SizedBox(
            width: 24,
            child: Text(
              '',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Seats
          ...row.map((seat) {
            if (seat.label.isEmpty) {
              // Aisle
              return Expanded(
                child: Center(
                  child: Text(
                    '$rowNumber',
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }
            return Expanded(child: _buildSeat(context, seat));
          }),
          // Row number right
          SizedBox(
            width: 24,
            child: Text(
              '$rowNumber',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(BuildContext context, SeatInfo seat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final isSelected = _selectedSeat == seat.label;
    final isOccupied = seat.type == SeatType.occupied;

    Color bgColor;
    Color textColor;
    String displayText;

    if (isSelected) {
      bgColor = const Color(0xFF1565C0);
      textColor = Colors.white;
      displayText = 'T1';
    } else if (isOccupied) {
      bgColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;
      textColor = Colors.transparent;
      displayText = '×';
    } else {
      bgColor = isDark ? const Color(0xFF1E2433) : Colors.grey.shade100;
      textColor = colors.onSurface;
      displayText = seat.extraPrice > 0
          ? '\$${seat.extraPrice.toInt()}'
          : '\$53';
    }

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
              setState(() {
                if (_selectedSeat == seat.label) {
                  _selectedSeat = null;
                  _seatPrice = 0;
                } else {
                  _selectedSeat = seat.label;
                  _seatPrice = seat.extraPrice > 0 ? seat.extraPrice : 53;
                }
              });
            },
      child: Container(
        height: 38,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: isOccupied
              ? null
              : Border.all(
                  color: isSelected
                      ? const Color(0xFF1565C0)
                      : (isDark
                            ? const Color(0xFF3A4556)
                            : Colors.grey.shade400),
                  width: isSelected ? 2 : 1,
                ),
        ),
        child: Center(
          child: isOccupied
              ? Icon(
                  Icons.close,
                  size: 14,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                )
              : Text(
                  displayText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
