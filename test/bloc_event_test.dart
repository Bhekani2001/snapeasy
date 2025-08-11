import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/models/card_model.dart';

void main() {
  group('CardEvent Tests', () {
    test('AddCard event holds correct card', () {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      final event = AddCard(card);
      expect(event.card, card);
    });

    test('RemoveCard event holds correct id', () {
      final event = RemoveCard('4000001234567890');
      expect(event.id, '4000001234567890');
    });

    test('FilterCardsByCountry event holds correct country', () {
      final event = FilterCardsByCountry('USA');
      expect(event.country, 'USA');
    });

    test('CardBanCheck event holds correct cardType and country', () {
      final event = CardBanCheck(cardType: 'MasterCard', country: 'USA');
      expect(event.cardType, 'MasterCard');
      expect(event.country, 'USA');
    });
  });
}
