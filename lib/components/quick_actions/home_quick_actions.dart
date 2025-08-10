import 'package:flutter/material.dart';
import 'package:snapeasy/components/navigations/nav_actions.dart';
import 'package:snapeasy/views/settings_screen.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({Key? key}) : super(key: key);

  Widget _actionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Color(0xFF2980B9)),
              SizedBox(height: 12),
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _actionCard("My Cards", Icons.credit_card, () => NavActions.showCardsAction(context)),
          _actionCard("Rewards", Icons.card_giftcard, () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Rewards tapped")),
            );
          }),
          _actionCard("Buy", Icons.shopping_cart, () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Buy tapped")),
            );
          }),
          _actionCard("Settings", Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            );
          }),
        ],
      ),
    );
  }
}
