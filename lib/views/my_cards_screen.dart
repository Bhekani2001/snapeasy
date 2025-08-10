import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/views/home_screen.dart';
import 'package:snapeasy/models/card_model.dart';

class MyCardsScreen extends StatefulWidget {
  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<CardBloc>(context).add(LoadCards());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Your SnapEZ Cards',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
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
              padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
              itemCount: state.cards.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Slide hint message at the top
                  return Container(
                    margin: EdgeInsets.only(bottom: 14),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.swipe, color: Color(0xFF56ab2f), size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Slide left on a card to see actions",
                            style: TextStyle(
                              color: Color(0xFF2e7d32),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final card = state.cards[index - 1];

                return Column(
                  children: [
                    Slidable(
                      key: ValueKey(card.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.3,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Add your delete logic here
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            icon: Icons.delete_forever,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: CardFlipWidget(card: card),
                    ),
                    SizedBox(height: 20),
                  ],
                );
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

  void _requestPinAndFlip() async {
    final pinController = TextEditingController();
    bool error = false;
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedPadding(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: Color(0xFF2980B9), size: 40),
                  SizedBox(height: 12),
                  Text('Enter Card PIN',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2980B9))),
                  SizedBox(height: 18),
                  Text('To view card details, please enter your 6-digit PIN.',
                      style: TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center),
                  SizedBox(height: 18),
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'PIN',
                      border: OutlineInputBorder(),
                      errorText: error ? 'Incorrect PIN!' : null,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          child: Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2980B9),
                            side: BorderSide(color: Color(0xFF2980B9)),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Unlock'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2980B9),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            if (pinController.text == widget.card.pin) {
                              Navigator.of(context).pop(true);
                            } else {
                              error = true;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Incorrect PIN!'), backgroundColor: Colors.redAccent),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (result == true) {
      setState(() {
        _isFlipped = !_isFlipped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 32;
    final double cardHeight = cardWidth / 1.58;

    return GestureDetector(
      onTap: _requestPinAndFlip,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _isFlipped ? pi : 0),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        builder: (context, double angle, child) {
          final isBack = angle > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildBack(widget.card, cardWidth, cardHeight),
                  )
                : _buildFront(widget.card, cardWidth, cardHeight),
          );
        },
      ),
    );
  }

  Widget _buildFront(CardModel card, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF56ab2f), Color(0xFF2980B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Icon(Icons.credit_card, color: Colors.white70, size: 32),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.amber[200],
              ),
              child: Center(
                child: Text(card.cardType ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: Text(card.bankName ?? '', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Text(
              '${card.firstName} ${card.lastName}',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              '•••• •••• •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(CardModel card, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF2980B9), Color(0xFF56ab2f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 20),
            color: Colors.black87,
            child: Center(
              child: Text(card.cardType ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card Number: ${card.cardNumber}', style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 8),
                Text('CVV: ${card.cvv}', style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 8),
                Text('Expiry: ${card.expiry}', style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 8),
                Text('Country: ${card.country}', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text('City: ${card.city}', style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 8),
                Text('Bank: ${card.bankName ?? ''}', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
