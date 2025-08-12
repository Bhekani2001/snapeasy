import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/notification_bloc.dart';
import 'package:snapeasy/bloc/notification_event.dart';
import 'package:snapeasy/components/quick_actions/home_quick_actions.dart';
import 'package:snapeasy/components/navigations/custom_bottom_nav_bar.dart';
import 'package:snapeasy/components/navigations/nav_actions.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/repositories/notification_repo_impl.dart';
import 'package:snapeasy/views/notification_screen.dart';

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
      context.read<CardBloc>().add(LoadCards());
    });
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
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

  Widget _welcomeCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF56ab2f), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.waving_hand_rounded, size: 52, color: Colors.white, semanticLabel: 'Welcome icon'),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Hello, welcome back to SnapEZ!\nManage your cards and payments with ease.",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                semanticsLabel: 'Welcome message',
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
          return const SizedBox(
              height: 180, child: Center(child: CircularProgressIndicator()));
        } else if (state is CardsLoaded) {
          if (state.cards.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: _openAddCardScanner,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.credit_card_off, color: Colors.white70, size: 48),
                      SizedBox(height: 12),
                      Text(
                        "No cards found",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Tap here to add your first SnapEZ card.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: previewCards.length,
                  itemBuilder: (context, index) =>
                      _buildStaticCard(previewCards[index]),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showCardsAction,
                  child: const Text("View All",
                      style: TextStyle(color: Color(0xFF2980B9))),
                ),
              ),
            ],
          );
        } else if (state is CardError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(state.message, style: const TextStyle(color: Colors.red)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStaticCard(CardModel card) {
    final displayName =
        "${card.firstName} ${card.lastName}".trim();
    final cardNumber = card.cardNumber;
    final maskedNumber = cardNumber.length >= 4
        ? "•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}"
        : "•••• •••• ••••";

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(displayName,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(maskedNumber,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 16, letterSpacing: 1.5)),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.credit_card, color: Colors.white70, size: 32, semanticLabel: 'Card icon'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("SnapEZ",
            style: TextStyle(
                color: Color(0xFF2980B9), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF2980B9)),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<NotificationBloc>(
                    create: (context) => NotificationBloc(NotificationRepoImpl())..add(LoadNotifications()),
                    child: NotificationScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeCard(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Your Cards",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _recentCardsSection(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const HomeQuickActions(),
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
