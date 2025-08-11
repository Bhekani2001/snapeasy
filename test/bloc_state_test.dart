import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/bloc/card_state.dart';
import 'package:snapeasy/models/card_model.dart';
// ...existing code...

void main() {
  group('CardState Tests', () {
    test('CardInitial is a CardState', () {
      expect(CardInitial(), isA<CardState>());
    });

    test('CardLoading is a CardState', () {
      expect(CardLoading(), isA<CardState>());
    });

    test('CardsLoaded holds correct cards', () {
      final cards = [CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America')];
      final state = CardsLoaded(cards);
      expect(state.cards, cards);
    });

    test('CardError holds correct message', () {
      final state = CardError('error occurred');
      expect(state.message, 'error occurred');
    });

    test('CardRemoved holds correct id', () {
      final state = CardRemoved('4000001234567890');
      expect(state.id, '4000001234567890');
    });
  });
}
