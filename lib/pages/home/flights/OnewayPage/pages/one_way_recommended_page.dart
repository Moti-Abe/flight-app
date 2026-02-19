import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/one_way_models.dart';
import '../models/one_way_mock_data.dart';
import '../widgets/one_way_flight_card.dart';
import 'one_way_select_fare_page.dart';

/// Page 2: Recommended departing flights with horizontal date-price scroller.
class OneWayRecommendedPage extends StatefulWidget {
  final OneWaySearchCriteria criteria;

  const OneWayRecommendedPage({super.key, required this.criteria});

  @override
  State<OneWayRecommendedPage> createState() => _OneWayRecommendedPageState();
}

class _OneWayRecommendedPageState extends State<OneWayRecommendedPage> {
  late DateTime _selectedDate;
  late List<OneWayFlight> _flights;
  late Map<DateTime, double> _datePrices;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.criteria.departDate;
    _datePrices = generateDatePrices(
      widget.criteria.from,
      widget.criteria.to,
      _selectedDate,
      cabin: widget.criteria.cabinClass,
    );
    _loadFlights();
  }

  void _loadFlights() {
    _flights = generateOneWayFlights(
      widget.criteria.from,
      widget.criteria.to,
      _selectedDate,
      cabin: widget.criteria.cabinClass,
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadFlights();
    });
  }

  String get _fromCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.from);
    return match?.group(1) ?? widget.criteria.from.split(' ').first;
  }

  String get _toCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.to);
    return match?.group(1) ?? widget.criteria.to.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : colors.surface;

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchPillBar(context),
            _buildDatePriceScroller(context),
            Expanded(
              child: _flights.isEmpty
                  ? _buildEmptyState(context)
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        _buildWatchPrices(context),
                        _buildDisclaimer(context),
                        _buildSectionHeader(context),
                        ..._flights.map(
                          (flight) => OneWayFlightCard(
                            flight: flight,
                            onSelect: () => _openSelectFare(context, flight),
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

  // ─── Search Pill App Bar (Expedia style) ───
  Widget _buildSearchPillBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final pillBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final pillBorder = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;

    final dateText =
        '${DateFormat('MMM d').format(_selectedDate)}  ·  ${widget.criteria.travelers} traveler${widget.criteria.travelers > 1 ? 's' : ''}';

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDD835),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_fromCode → $_toCode',
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
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ─── Horizontal date-price scroller ───
  Widget _buildDatePriceScroller(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final sortedDates = _datePrices.keys.toList()..sort();
    final formatter = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    );

    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF2A3141) : Colors.grey.shade200,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          final date = sortedDates[index];
          final price = _datePrices[date]!;
          final isSelected =
              date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          return GestureDetector(
            onTap: () => _selectDate(date),
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                          ? const Color(0xFF1A2340)
                          : const Color(0xFFE3F2FD))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: const Color(0xFF1565C0), width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E, MMM d').format(date),
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF1565C0))
                          : colors.onSurface,
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatter.format(price),
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF1565C0))
                          : colors.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Watch prices card ───
  Widget _buildWatchPrices(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Watch prices',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Get push notifications if prices go up or down',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close,
                size: 18,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Container(
                width: 40,
                height: 22,
                decoration: BoxDecoration(
                  color: colors.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Disclaimer ───
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

  // ─── Section header ───
  Widget _buildSectionHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended departing flights',
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

  // ─── Empty state ───
  Widget _buildEmptyState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 64,
            color: colors.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No flights found for this route',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sort & Filter FAB ───
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
      child: Material(
        color: isDark ? const Color(0xFF151A24) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  size: 18,
                  color: isDark
                      ? const Color(0xFF7FB5FF)
                      : const Color(0xFF1565C0),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sort & Filter',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF7FB5FF)
                        : const Color(0xFF1565C0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Navigation ───
  void _openSelectFare(BuildContext context, OneWayFlight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OneWaySelectFarePage(flight: flight, criteria: widget.criteria),
      ),
    );
  }
}
