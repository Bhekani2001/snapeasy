import 'package:flutter/material.dart';
import 'package:snapeasy/views/my_cards_screen.dart';
import 'package:snapeasy/views/add_card_scan_screen.dart';

class NavActions {
  static void showCardsAction(BuildContext context) {
    if (!Navigator.canPop(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyCardsScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyCardsScreen()),
      );
    }
  }

  static void openAddCardScanner(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (context) => AddCardScanScreen()),
    );
  }

  static void showTransactionsAction(BuildContext context) {
    _showSnackBar(context, _transactionsSnackBar);
  }

  static void showMenuAction(BuildContext context) {
    _showSnackBar(context, _menuSnackBar);
  }

  static void _showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static const SnackBar _transactionsSnackBar = SnackBar(
    content: Text("Opening Transactions..."),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar _menuSnackBar = SnackBar(
    content: Text("Opening Menu..."),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
  );
}
