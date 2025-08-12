import 'package:flutter/material.dart';
import 'package:card_scanner/card_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';
import 'package:snapeasy/views/add_card_manual.dart';

class AddCardScanScreen extends StatefulWidget {
  @override
  State<AddCardScanScreen> createState() => _AddCardScanScreenState();
}

class _AddCardScanScreenState extends State<AddCardScanScreen> {
  String? _cardType;
  String? _bankName;

  String? _detectCardType(String? cardNumber) {
    if (cardNumber == null) return null;
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'MasterCard';
    if (cardNumber.startsWith('3')) return 'American Express';
    if (cardNumber.startsWith('6')) return 'Discover';
    return 'Unknown';
  }

  String? _detectBankName(String? cardNumber) {
    if (cardNumber == null || cardNumber.length < 6) return null;
    final bin = cardNumber.substring(0, 6);
    switch (bin) {
      case '528497':
      case '528498':
      case '528499':
        return 'Capitec Bank';

      case '603493':
      case '603494':
      case '627010':
        return 'Absa Bank';

      case '520000':
      case '520001':
      case '436414':
      case '521234':
        return 'FNB';

      case '450801':
      case '450802':
      case '450803':
      case '450804':
      case '540000':
      case '541000':
        return 'Nedbank';

      default:
        final binInt = int.tryParse(bin);
        if (binInt != null && binInt >= 541200 && binInt <= 541299) {
          return 'Nedbank';
        }
        return 'Unknown Bank';
    }
  }

  CardDetails? _cardDetails;
  bool _isScanning = false;
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  Future<void> _scanCard() async {
    setState(() => _isScanning = true);

    final CardDetails? details = await CardScanner.scanCard(
      scanOptions: const CardScanOptions(
        scanCardHolderName: true,
        validCardsToScanBeforeFinishingScan: 1,
      ),
    );

    setState(() {
      _isScanning = false;
      _cardDetails = details;
      _cardType = _detectCardType(details?.cardNumber);
      _bankName = _detectBankName(details?.cardNumber);
    });

    if (details != null) {
      await Future.delayed(Duration(seconds: 2));
      _continueToManualForm();
    }
  }

  void _continueToManualForm() async {
    if (_cardDetails == null) return;
    final cardBloc = BlocProvider.of<CardBloc>(context);
    final repo = cardBloc.viewModel.repository;
    final cardNumber = _cardDetails!.cardNumber;
    bool exists = false;
    if (repo is CardRepoImpl) {
      exists = await repo.isCardExists(cardNumber);
    }
    if (exists) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Duplicate Card', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Icon(Icons.warning, color: Colors.orange, size: 48),
                SizedBox(height: 16),
                Text('This card is already saved in your wallet.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
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
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddCardManualScreen(
        initialCardNumber: _cardDetails!.cardNumber,
        initialExpiry: _cardDetails!.expiryDate,
        initialCVV: _cvvController.text,
      ),
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
                        _infoRow("Cardholder Name:", _cardDetails!.cardHolderName),
                        if (_cardType != null)
                          _infoRow("Card Type:", _cardType!),
                        if (_bankName != null)
                          _infoRow("Bank Name:", _bankName!),
                       
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
                    builder: (context) => AddCardManualScreen(),
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
