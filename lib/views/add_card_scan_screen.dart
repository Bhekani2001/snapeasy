import 'package:flutter/material.dart';
import 'package:card_scanner/card_scanner.dart';

class AddCardScanScreen extends StatefulWidget {
  @override
  _AddCardScanScreenState createState() => _AddCardScanScreenState();
}

class _AddCardScanScreenState extends State<AddCardScanScreen> {
  CardDetails? _cardDetails;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startCardScan();
  }

  Future<void> _startCardScan() async {
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

    if (details != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Card Detected: ${details.cardNumber}")),
      );
      Navigator.pop(context, details); // Return scanned card details
    }
  }

  Widget _buildCardInfo() {
    if (_isScanning) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            "Scanning card...",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      );
    }

    if (_cardDetails == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 80),
          SizedBox(height: 20),
          Text(
            "No card detected",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      );
    }

    // Show scanned card details
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
          SizedBox(height: 20),
          Text(
            "Card scanned successfully!",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _infoRow("Card Number:", _cardDetails!.cardNumber ?? "N/A"),
          _infoRow("Expiry Date:", _cardDetails!.expiryDate ?? "N/A"),
          _infoRow("Cardholder Name:", _cardDetails!.cardHolderName ?? "N/A"),
        ],
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
      body: Center(child: _buildCardInfo()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
