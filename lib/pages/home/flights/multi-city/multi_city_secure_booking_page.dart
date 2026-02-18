import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'multi_city_booking_confirmation_page.dart';

class MultiCitySecureBookingPage extends StatefulWidget {
  final MultiCitySelection selection;
  final double total;

  const MultiCitySecureBookingPage({
    super.key,
    required this.selection,
    required this.total,
  });

  @override
  State<MultiCitySecureBookingPage> createState() =>
      _MultiCitySecureBookingPageState();
}

class _MultiCitySecureBookingPageState
    extends State<MultiCitySecureBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String paymentMethod = 'Visa';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _completeBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiCityBookingConfirmationPage(
          selection: widget.selection,
          total: widget.total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark
        ? const Color(0xFF0B0F1A)
        : Colors.white;
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
              _buildField(
                label: 'Passport number (optional)',
                controller: _passportController,
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
              _buildTotalRow('Total to pay', formatter.format(widget.total)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
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
    final fillColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.72);
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
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: paymentMethod,
        items: const [
          DropdownMenuItem(value: 'Visa', child: Text('Visa')),
          DropdownMenuItem(value: 'Mastercard', child: Text('Mastercard')),
          DropdownMenuItem(value: 'Amex', child: Text('American Express')),
        ],
        onChanged: (value) => setState(() => paymentMethod = value ?? 'Visa'),
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
    final cardColor = isDark
        ? const Color(0xFF111624)
        : colors.surface.withValues(alpha: 0.72);
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final barColor = isDark
        ? const Color(0xFF0B0F1A)
        : colors.surface.withValues(alpha: 0.9);
    final borderColor = isDark
        ? const Color(0xFF1E2433)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          onPressed: _completeBooking,
          child: const Text('Complete booking'),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }
}
