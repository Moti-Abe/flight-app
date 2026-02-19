import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/round_trip_models.dart';
import 'rt_booking_confirmation_page.dart';

/// Page 8: Secure booking — traveler info + payment form for round-trip.
class RtSecureBookingPage extends StatefulWidget {
  final RoundTripBooking booking;

  const RtSecureBookingPage({super.key, required this.booking});

  @override
  State<RtSecureBookingPage> createState() => _RtSecureBookingPageState();
}

class _RtSecureBookingPageState extends State<RtSecureBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _paymentMethod = 'Visa';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  double get _totalPrice => widget.booking.totalPrice;

  void _completeBooking() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RtBookingConfirmationPage(booking: widget.booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final formatter = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        foregroundColor: colors.onSurface,
        title: const Text('Secure booking'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              _buildFlightSummary(
                context,
                'Departing flight',
                widget.booking.departureFlight,
              ),
              const SizedBox(height: 12),
              _buildFlightSummary(
                context,
                'Return flight',
                widget.booking.returnFlight,
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Traveler details'),
              _buildField(
                label: 'Full name',
                controller: _nameController,
                validator: _requiredValidator,
              ),
              _buildField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
              ),
              _buildField(
                label: 'Phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Payment method'),
              _buildDropdown(),
              _buildField(
                label: 'Card number',
                controller: _cardController,
                keyboardType: TextInputType.number,
                validator: _requiredValidator,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: 'Expiry date',
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      label: 'CVV',
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      validator: _requiredValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTotalRow('Total to pay', formatter.format(_totalPrice)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildFlightSummary(
    BuildContext context,
    String label,
    RoundTripFlight flight,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final fromName = flight.fromCity.split(' (').first;
    final toName = flight.toCity.split(' (').first;

    // Determine which seat to show
    String? seatLabel;
    if (label.contains('Departing')) {
      seatLabel = widget.booking.departureSeat;
    } else {
      seatLabel = widget.booking.returnSeat;
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _summaryRow(context, 'Route', '$fromName → $toName'),
          _summaryRow(context, 'Date', flight.dateLabel),
          _summaryRow(
            context,
            'Time',
            '${flight.departTime} – ${flight.arriveTime}',
          ),
          _summaryRow(context, 'Airline', flight.airline),
          _summaryRow(context, 'Fare', widget.booking.fare.name),
          if (seatLabel != null) _summaryRow(context, 'Seat', seatLabel),
          if (widget.booking.baggage != null)
            _summaryRow(context, 'Bags', widget.booking.baggage!.label),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.6)),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: _paymentMethod,
        items: const [
          DropdownMenuItem(value: 'Visa', child: Text('Visa')),
          DropdownMenuItem(value: 'Mastercard', child: Text('Mastercard')),
          DropdownMenuItem(value: 'Amex', child: Text('American Express')),
        ],
        onChanged: (value) => setState(() => _paymentMethod = value ?? 'Visa'),
        dropdownColor: fillColor,
        iconEnabledColor: colors.onSurface.withValues(alpha: 0.75),
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: 'Payment method',
          labelStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.6)),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF111624) : Colors.grey.shade50;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: colors.onSurface.withValues(alpha: 0.75)),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E2433) : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: _completeBooking,
            child: const Text(
              'Complete Booking',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (!v.contains('@')) return 'Enter a valid email';
    return null;
  }
}
