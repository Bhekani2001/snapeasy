import 'package:flutter/material.dart';
import 'package:snapeasy/views/my_cards_screen.dart';

class CardSuccessScreen extends StatelessWidget {
  final bool isManual;

  const CardSuccessScreen({Key? key, required this.isManual}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace Icon with success image
            Image.asset(
              'lib/images/ic_success.png',
              width: 80,
              height: 80,
            ),
            SizedBox(height: 24),
            Text(
              isManual ? 'Card Added Manually!' : 'Card Scanned & Saved!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Your card has been added successfully.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_forward),
              label: Text('Go to Cards List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyCardsScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
