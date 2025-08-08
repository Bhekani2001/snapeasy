import 'package:flutter/material.dart';
import 'package:snapeasy/views/add_card_scan_screen.dart';
import 'package:snapeasy/views/my_cards_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home tapped
        break;
      case 1:
        _showCardsAction();
        break;
      case 2:
        _openAddCardScanner();
        break;
      case 3:
        _showTransactionsAction();
        break;
      case 4:
        _showMenuAction();
        break;
    }
  }

  void _showCardsAction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyCardsScreen()),
    );
  }

  void _openAddCardScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCardScanScreen()),
    );
  }

  void _showTransactionsAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening Transactions...")),
    );
    // TODO: Navigate to Transactions screen later
  }

  void _showMenuAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening Menu...")),
    );
    // TODO: Navigate to Menu screen later
  }

  final Widget _welcomeCard = Padding(
    padding: const EdgeInsets.all(24.0),
    child: Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black38,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF56ab2f), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.waving_hand_rounded,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                "Hello, welcome back to SnapEZ! Manage your cards and payments with ease.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SnapEZ"),
        centerTitle: true,
        backgroundColor: Color(0xFF2980B9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _welcomeCard,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'My Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 30),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        selectedItemColor: Color(0xFF56ab2f),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
