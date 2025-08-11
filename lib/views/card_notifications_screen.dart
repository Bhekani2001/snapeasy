import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_state.dart';

class CardNotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Notifications'),
        backgroundColor: Colors.deepOrange.shade700,
        elevation: 0,
      ),
      body: BlocBuilder<CardBloc, CardState>(
        builder: (context, state) {
          if (state is CardsLoaded) {
            final now = DateTime.now();
            final fourYearsFromNow = DateTime(now.year + 3, now.month);
            final expiringCards = state.cards.where((card) {
              try {
                final parts = card.expiry.split('/');
                if (parts.length != 2) return false;
                final month = int.tryParse(parts[0]);
                final year = int.tryParse(parts[1]);
                if (month == null || year == null) return false;

                final exp = DateTime(2000 + year, month);
                return exp.isBefore(fourYearsFromNow);
              } catch (_) {
                return false;
              }
            }).toList();
            if (expiringCards.isEmpty) {
              return Center(child: Text('No cards expiring within 4 years.'));
            }
            return ListView.builder(
              itemCount: expiringCards.length,
              itemBuilder: (context, index) {
                final card = expiringCards[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.deepOrange.shade700),
                    title: Text('${card.firstName} ${card.lastName}'),
                    subtitle: Text('Expires: ${card.expiry}'),
                    trailing: Text('Expiring Soon', style: TextStyle(color: Colors.red)),
                  ),
                );
              },
            );
          } else if (state is CardLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Unable to load card notifications.'));
          }
        },
      ),
    );
  }
}
