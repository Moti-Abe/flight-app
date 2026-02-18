import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mock_flights.dart';
import 'models.dart';
import 'multi_city_flight_details_page.dart';
import 'multi_city_review_fare_page.dart';
import 'widgets/multi_city_flight_card.dart';

class MultiCityRecommendedPage extends StatelessWidget {
  final MultiCitySelection selection;
  final int segmentIndex;

  const MultiCityRecommendedPage({
    super.key,
    required this.selection,
    required this.segmentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground =
        isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final criteria = selection.criteria;
    final segmentFrom = _segmentFrom(criteria, segmentIndex);
    final segmentTo = _segmentTo(criteria, segmentIndex);
    final segmentDate = _segmentDate(criteria, segmentIndex);

    final filteredFlights =
        (segmentFrom == null || segmentTo == null || segmentDate == null)
            ? <MultiCityFlight>[]
            : generateFlightsForRoute(segmentFrom, segmentTo, segmentDate);

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchPillBar(context, criteria),
            Expanded(
              child: filteredFlights.isEmpty
                  ? _buildEmptyState(context)
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        _buildPromoBanner(context),
                        _buildDisclaimer(context),
                        _buildSectionHeader(context),
                        ...filteredFlights.map(
                          (flight) => MultiCityFlightCard(
                            flight: flight,
                            onSelect: () => _openReviewFare(
                              context,
                              flight,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSortFilterFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ──────────── Search Pill App Bar ────────────
  Widget _buildSearchPillBar(
    BuildContext context,
    MultiCitySearchCriteria criteria,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final pillBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final pillBorder = isDark
        ? const Color(0xFF2A3141)
        : Colors.grey.shade300;

    final routeText = _buildRouteLine(criteria);
    final dateText =
        '${DateFormat('MMM d').format(criteria.depart1)}-${DateFormat('MMM d').format(criteria.depart2)}'
        '${criteria.hasThirdLeg ? '-${DateFormat('MMM d').format(criteria.depart3!)}' : ''}'
        '  ·  ${criteria.travelers} traveler${criteria.travelers > 1 ? 's' : ''}';

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back arrow
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          // Search pill
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: pillBorder),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  // Yellow search circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDD835),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search, size: 20, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          routeText,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateText,
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Share icon
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ──────────── Promo Banner ────────────
  Widget _buildPromoBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diamond icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1A2340)
                  : const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              color: Color(0xFF1565C0),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a flight and get \$20 in OneKeyCash to use toward your next trip',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Receive within 48 hours, use within 30 days. See terms',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────── Disclaimer ────────────
  Widget _buildDisclaimer(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'Prices may change based on availability and are not final until you '
        'complete your purchase. You can review any additional fees before checkout.',
        style: TextStyle(
          color: colors.onSurface.withValues(alpha: 0.55),
          fontSize: 12,
        ),
      ),
    );
  }

  // ──────────── Section Header ────────────
  Widget _buildSectionHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended flights',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'How our sort order works and personalized pricing',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.55),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                size: 14,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────── Sort & Filter FAB ────────────
  Widget _buildSortFilterFab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.tune, size: 18),
        label: const Text('Sort & Filter'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF1E2433) : Colors.white,
          foregroundColor: isDark
              ? const Color(0xFF7FB5FF)
              : const Color(0xFF1565C0),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: isDark
                  ? const Color(0xFF2A3141)
                  : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  // ──────────── Empty State ────────────
  Widget _buildEmptyState(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: textColor.withValues(alpha: 0.6),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'No flights match your selections.',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try another date or city pair.',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── Open Review Fare Page ────────────
  void _openReviewFare(BuildContext context, MultiCityFlight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiCityReviewFarePage(
          flight: flight,
          onSelect: () => _handleSelect(context, flight),
        ),
      ),
    );
  }

  // ──────────── Flight Selection Logic ────────────
  void _handleSelect(BuildContext context, MultiCityFlight flight) {
    if (segmentIndex == 1) {
      final nextSelection = selection.copyWith(flight1: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiCityRecommendedPage(
            selection: nextSelection,
            segmentIndex: 2,
          ),
        ),
      );
    } else if (segmentIndex == 2 && selection.criteria.hasThirdLeg) {
      final nextSelection = selection.copyWith(flight2: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiCityRecommendedPage(
            selection: nextSelection,
            segmentIndex: 3,
          ),
        ),
      );
    } else if (segmentIndex == 2) {
      final nextSelection = selection.copyWith(flight2: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiCityFlightDetailsPage(selection: nextSelection),
        ),
      );
    } else {
      final nextSelection = selection.copyWith(flight3: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiCityFlightDetailsPage(selection: nextSelection),
        ),
      );
    }
  }

  // ──────────── Helpers ────────────
  String _buildRouteLine(MultiCitySearchCriteria criteria) {
    String shorten(String city) {
      final match = RegExp(r'\((\w+)\)').firstMatch(city);
      return match != null ? match.group(1)! : city.split(' ').first;
    }

    final segments = [
      shorten(criteria.from1),
      shorten(criteria.to1),
      shorten(criteria.to2),
    ];
    if (criteria.hasThirdLeg) {
      segments.add(shorten(criteria.to3!));
    }
    return segments.join(' → ');
  }

  String? _segmentFrom(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.from1;
      case 2:
        return criteria.from2;
      case 3:
        return criteria.from3;
      default:
        return null;
    }
  }

  String? _segmentTo(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.to1;
      case 2:
        return criteria.to2;
      case 3:
        return criteria.to3;
      default:
        return null;
    }
  }

  DateTime? _segmentDate(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.depart1;
      case 2:
        return criteria.depart2;
      case 3:
        return criteria.depart3;
      default:
        return null;
    }
  }

}
