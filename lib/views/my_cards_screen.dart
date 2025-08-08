import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/models/card_model.dart';

class MyCardsScreen extends StatefulWidget {
  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cards'),
        backgroundColor: Color(0xFF2980B9),
      ),
      body: BlocBuilder<CardBloc, CardState>(
        builder: (context, state) {
          if (state is CardLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CardsLoaded) {
            if (state.cards.isEmpty) {
              return Center(child: Text('No cards found.'));
            }
            return ListView.builder(
              itemCount: state.cards.length,
              itemBuilder: (context, index) {
                return CardFlipWidget(card: state.cards[index]);
              },
            );
          } else if (state is CardError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No cards found.'));
        },
      ),
    );
  }
}

class CardFlipWidget extends StatefulWidget {
  final CardModel card;
  const CardFlipWidget({Key? key, required this.card}) : super(key: key);

  @override
  State<CardFlipWidget> createState() => _CardFlipWidgetState();
}

class _CardFlipWidgetState extends State<CardFlipWidget> {
  bool _isFlipped = false;

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 200,
        child: _isFlipped ? _buildBack(widget.card) : _buildFront(widget.card),
      ),
    );
  }

  Widget _buildFront(CardModel card) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF56ab2f), Color(0xFF2980B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 24,
            left: 24,
            child: Text(
              card.firstName + ' ' + card.lastName,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 24,
            child: Container(
              width: 220,
              child: Text(
                '•••• •••• •••• ' + card.cardNumber.substring(card.cardNumber.length - 4),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 24,
            child: Icon(Icons.remove_red_eye, color: Colors.white70, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(CardModel card) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF2980B9), Color(0xFF56ab2f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Card Number: ' + card.cardNumber, style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 12),
            Text('CVV: ' + card.cvv, style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 12),
            Text('Expiry: ' + card.expiry, style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 12),
            Text('Country: ' + card.country, style: TextStyle(color: Colors.white, fontSize: 16)),
            Text('City: ' + card.city, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
