import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/components/quick_actions/home_quick_actions.dart';
import 'package:snapeasy/views/add_card_scan_screen.dart';
import 'package:snapeasy/components/navigations/custom_bottom_nav_bar.dart';
import 'package:snapeasy/components/navigations/nav_actions.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/models/card_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<CardBloc>(context).add(LoadCards());
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
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

  void _showCardsAction() => NavActions.showCardsAction(context);
  void _openAddCardScanner() => NavActions.openAddCardScanner(context);
  void _showTransactionsAction() => NavActions.showTransactionsAction(context);
  void _showMenuAction() => NavActions.showMenuAction(context);

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Notifications tapped")),
    );
  }

  Widget _welcomeCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF56ab2f), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.waving_hand_rounded, size: 52, color: Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Hello, welcome back to SnapEZ!\nManage your cards and payments with ease.",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentCardsSection() {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        if (state is CardLoading) {
          return SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
        } else if (state is CardsLoaded) {
          if (state.cards.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("No cards found.", style: TextStyle(color: Colors.grey)),
            );
          }

          final previewCards = state.cards.take(2).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: previewCards.length,
                  itemBuilder: (context, index) {
                    return _buildStaticCard(previewCards[index]);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showCardsAction,
                  child: Text("View All", style: TextStyle(color: Color(0xFF2980B9))),
                ),
              ),
            ],
          );
        } else if (state is CardError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildStaticCard(CardModel card) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${card.firstName} ${card.lastName}",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text("•••• •••• •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}",
              style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1.5)),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.credit_card, color: Colors.white70, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsGrid() {
    final actions = [
      {"icon": Icons.credit_card, "label": "My Cards", "action": _showCardsAction},
      {"icon": Icons.add_card, "label": "Add Card", "action": _openAddCardScanner},
      {"icon": Icons.receipt_long, "label": "Transactions", "action": _showTransactionsAction},
      {"icon": Icons.menu, "label": "Menu", "action": _showMenuAction},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: actions.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final item = actions[index];
          return _buildQuickAction(item["icon"] as IconData, item["label"] as String, item["action"] as VoidCallback);
        },
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF2980B9)),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("SnapEZ", style: TextStyle(color: Color(0xFF2980B9), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 36, color: Color(0xFF2980B9)),
            onPressed: _showNotifications,
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Your Cards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _recentCardsSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            HomeQuickActions(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
