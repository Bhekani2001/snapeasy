import 'package:flutter/material.dart';
import 'package:card_scanner/card_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';
import 'package:snapeasy/views/card_success.dart';

class AddCardScanScreen extends StatefulWidget {
  @override
  State<AddCardScanScreen> createState() => _AddCardScanScreenState();
}

class _AddCardScanScreenState extends State<AddCardScanScreen> {
  CardDetails? _cardDetails;
  bool _isScanning = false;
  final TextEditingController _cvvController = TextEditingController();

  Future<void> _scanCard() async {
    setState(() => _isScanning = true);
    final CardDetails? details = await CardScanner.scanCard(
      scanOptions: CardScanOptions(
        scanCardHolderName: true,
        validCardsToScanBeforeFinishingScan: 1,
      ),
    );
    setState(() {
      _isScanning = false;
      _cardDetails = details;
    });
  }

  void _saveCard() async {
    if (_cardDetails == null || _cvvController.text.isEmpty) return;
    final card = CardModel(
      firstName: _cardDetails!.cardHolderName ?? '',
      lastName: '',
      cardNumber: _cardDetails!.cardNumber,
      cvv: _cvvController.text,
      expiry: _cardDetails!.expiryDate,
      country: '',
      city: '',
    );
    // Save card and wait for completion
    BlocProvider.of<CardBloc>(context).add(AddCard(card));
    await Future.delayed(Duration(milliseconds: 500)); // Give BLoC time to persist
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CardSuccessScreen(isManual: false)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 6,
            child: Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Scan Your Card"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _isScanning
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Scanning card...', style: TextStyle(color: Colors.white)),
                ],
              )
            : _cardDetails == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, size: 80, color: Colors.white),
                      SizedBox(height: 30),
                      Text('Tap below to scan your card', style: TextStyle(fontSize: 18, color: Colors.white)),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Start Scan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF56ab2f),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        onPressed: _scanCard,
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
                        SizedBox(height: 20),
                        Text("Card scanned successfully!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        _infoRow("Card Number:", _cardDetails!.cardNumber),
                        _infoRow("Expiry Date:", _cardDetails!.expiryDate),
                        _infoRow("Cardholder Name:", _cardDetails!.cardHolderName ?? "N/A"),
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save Card'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF56ab2f),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          onPressed: _cvvController.text.isEmpty ? null : _saveCard,
                        ),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.cancel, color: Colors.white),
                label: Text("Cancel", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text('Add Manually', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2980B9),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => _ManualCardForm(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualCardForm extends StatefulWidget {
  @override
  State<_ManualCardForm> createState() => _ManualCardFormState();
}

class _ManualCardFormState extends State<_ManualCardForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Widget _cardTypeIcon(String cardNumber) {
    final type = CardRepoImpl.detectCardType(cardNumber);
    switch (type) {
      case 'mastercard':
        return Icon(Icons.credit_card, color: Colors.deepPurple, size: 32);
      case 'visa':
        return Icon(Icons.credit_card, color: Colors.blue, size: 32);
      case 'amex':
        return Icon(Icons.credit_card, color: Colors.green, size: 32);
      case 'discover':
        return Icon(Icons.credit_card, color: Colors.orange, size: 32);
      default:
        return Icon(Icons.credit_card, color: Colors.grey, size: 32);
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final card = CardModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        cardNumber: _cardNumberController.text,
        cvv: _cvvController.text,
        expiry: _expiryController.text,
        country: _countryController.text,
        city: _cityController.text,
      );
      BlocProvider.of<CardBloc>(context).add(AddCard(card));
      await Future.delayed(Duration(milliseconds: 500)); // Give BLoC time to persist
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CardSuccessScreen(isManual: true)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Card Manually', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  suffixIcon: _cardTypeIcon(_cardNumberController.text),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Save Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF56ab2f),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
