import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';
import 'package:snapeasy/views/card_success.dart';
import 'package:snapeasy/models/country_status.dart';

class AddCardManualScreen extends StatefulWidget {
  final String? initialCardNumber;
  final String? initialExpiry;
  final String? initialCVV;

  const AddCardManualScreen({
    Key? key,
    this.initialCardNumber,
    this.initialExpiry,
    this.initialCVV,
  }) : super(key: key);

  @override
  State<AddCardManualScreen> createState() => _AddCardManualScreenState();
}

class _AddCardManualScreenState extends State<AddCardManualScreen> {
  final Map<String, List<int>> _brandLengths = {
    'visa': [13, 16, 19],
    'mastercard': [16],
    'amex': [15],
    'discover': [16, 19],
  };

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late TextEditingController _cardNumberController;
  late TextEditingController _cvvController;
  late TextEditingController _expiryController;
  String? _selectedCountry;
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController(text: widget.initialCardNumber ?? '');
    _cvvController = TextEditingController(text: widget.initialCVV ?? '');
    _expiryController = TextEditingController(text: widget.initialExpiry ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  String? _getCardNumberError(String cardNumber) {
    if (cardNumber.isEmpty) return null;

    final repo = BlocProvider.of<CardBloc>(context).viewModel.repository;
    String type = '';

    if (repo is CardRepoImpl) {
      type = CardRepoImpl.detectCardType(cardNumber);
    } else {
      if (cardNumber.startsWith('4')) type = 'visa';
      else if (cardNumber.startsWith('5')) type = 'mastercard';
      else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) type = 'amex';
      else if (cardNumber.startsWith('6')) type = 'discover';
      else type = '';
    }

    if (type.isEmpty) return 'Unsupported card brand';

    final allowedLengths = _brandLengths[type];
    if (allowedLengths == null) return 'Unsupported card brand';

    if (!allowedLengths.contains(cardNumber.length)) {
      return 'Card number length invalid for $type';
    }

    if (!_luhnCheck(cardNumber)) {
      return 'Card number failed Luhn check';
    }

    return null;
  }

  // Luhn algorithm to validate card number
  bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.tryParse(cardNumber[i]) ?? 0;

      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }

      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  Widget _cardTypeIcon(String cardNumber) {
    final repo = BlocProvider.of<CardBloc>(context).viewModel.repository;
    String type = '';

    if (repo is CardRepoImpl) {
      type = CardRepoImpl.detectCardType(cardNumber);
    } else {
      if (cardNumber.startsWith('4')) type = 'visa';
      else if (cardNumber.startsWith('5')) type = 'mastercard';
      else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) type = 'amex';
      else if (cardNumber.startsWith('6')) type = 'discover';
      else type = '';
    }

    switch (type) {
      case 'mastercard':
        return const Icon(Icons.credit_card, color: Colors.deepPurple, size: 32);
      case 'visa':
        return const Icon(Icons.credit_card, color: Colors.blue, size: 32);
      case 'amex':
        return const Icon(Icons.credit_card, color: Colors.green, size: 32);
      case 'discover':
        return const Icon(Icons.credit_card, color: Colors.orange, size: 32);
      default:
        return const Icon(Icons.credit_card, color: Colors.grey, size: 32);
    }
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedCountry == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Country Required'),
          content: const Text('Please select a country.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final countryObj = worldCountries.firstWhere((c) => c.name == _selectedCountry);

    final repo = BlocProvider.of<CardBloc>(context).viewModel.repository;
    String detectedCardType = '';

    if (repo is CardRepoImpl) {
      detectedCardType = CardRepoImpl.detectCardType(_cardNumberController.text);
    } else {
      final cardNumber = _cardNumberController.text;
      if (cardNumber.startsWith('4')) detectedCardType = 'visa';
      else if (cardNumber.startsWith('5')) detectedCardType = 'mastercard';
      else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) detectedCardType = 'amex';
      else if (cardNumber.startsWith('6')) detectedCardType = 'discover';
      else detectedCardType = '';
    }

    if (countryObj.bannedMastercard && detectedCardType == 'mastercard') {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Card Banned', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Icon(Icons.block, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Mastercards are banned in $_selectedCountry.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    String detectedBankName = 'Unknown Bank';
    final cardNumber = _cardNumberController.text;

    if (cardNumber.length >= 6) {
      final bin = cardNumber.substring(0, 6);
      switch (bin) {
        // Capitec Bank
        case '528497':
        case '528963':
          detectedBankName = 'Capitec Bank';
          break;

        // Nedbank
        case '431412':
        case '543772': // Nedbank Gold Mastercard credit
        case '557718':
          detectedBankName = 'Nedbank';
          break;

        // First National Bank (FNB)
        case '419565':
        case '536475':
        case '527212':
          detectedBankName = 'First National Bank (FNB)';
          break;

        // Absa Bank
        case '400154':
        case '524354':
        case '425328':
          detectedBankName = 'Absa Bank';
          break;

        // Discovery Bank
        case '536099':
        case '520474':
          detectedBankName = 'Discovery Bank';
          break;

        default:
          detectedBankName = 'Unknown Bank';
      }
    }

    final card = CardModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      cardNumber: cardNumber,
      cvv: _cvvController.text,
      expiry: _expiryController.text,
      country: _selectedCountry!,
      city: _cityController.text,
      pin: _pinController.text,
      cardType: detectedCardType,
      bankName: detectedBankName,
    );

    final bloc = BlocProvider.of<CardBloc>(context);
    final viewModel = bloc.viewModel;
    final result = await viewModel.addCard(card);

    if (result.success) {
      bloc.add(AddCard(card));
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CardSuccessScreen(isManual: true)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(result.error ?? 'Failed to save card.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.85), Colors.white.withOpacity(0.65)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.add_card, color: Color(0xFF56ab2f), size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Add Card Manually',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          suffixIcon: _cardTypeIcon(_cardNumberController.text),
                          errorText: _cardNumberController.text.isEmpty
                              ? null
                              : _getCardNumberError(_cardNumberController.text),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : _getCardNumberError(v),
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 4,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _expiryController,
                        decoration: InputDecoration(
                          labelText: 'Expiry Date (MM/YY)',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: worldCountries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country.name,
                            child: Text(
                              country.name + (country.bannedMastercard ? ' (Banned for Mastercards)' : ''),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pinController,
                        decoration: InputDecoration(
                          labelText: 'Card PIN',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save Card'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF56ab2f),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                        ),
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
