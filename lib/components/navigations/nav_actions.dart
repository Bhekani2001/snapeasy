import 'package:flutter/material.dart';
import 'package:snapeasy/views/my_cards_screen.dart';
import 'package:snapeasy/views/add_card_scan_screen.dart';

class NavActions {
  static void showCardsAction(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyCardsScreen()),
    );
  }

  static void openAddCardScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCardScanScreen()),
    );
  }

  static void showTransactionsAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening Transactions...")),
    );
  }

  static void showMenuAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening Menu...")),
    );
  }
}
