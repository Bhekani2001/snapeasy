import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/repositories/card_repository.dart';
import 'package:snapeasy/models/card_model.dart';

class TestCardRepository extends CardRepository {
  final List<CardModel> _cards = [];

  @override
  Future<List<CardModel>> getCards() async => _cards;
  @override
  Future<CardModel?> getCardById(String id) async {
    try {
      return _cards.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  @override
  Future<void> addCard(CardModel card) async => _cards.add(card);
  @override
  Future<void> updateCard(CardModel card) async {
    final idx = _cards.indexWhere((c) => c.id == card.id);
    if (idx != -1) _cards[idx] = card;
  }
  @override
  Future<void> removeCard(String id) async => _cards.removeWhere((c) => c.id == id);
  @override
  Future<bool> isCardExists(String cardNumber) async => _cards.any((c) => c.cardNumber == cardNumber);
  @override
  Future<void> clearAllCards() async => _cards.clear();
  @override
  Future<int> getCardCount() async => _cards.length;
  @override
  Future<void> migrateOldCardsIfNeeded() async {}
}

void main() {
  group('CardRepository Tests', () {
    late TestCardRepository repo;
    setUp(() {
      repo = TestCardRepository();
    });

    test('Add and get card', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      final cards = await repo.getCards();
      expect(cards.length, 1);
      expect(cards.first.cardNumber, '4000001234567890');
    });

    test('Get card by ID', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      final fetched = await repo.getCardById(card.id);
      expect(fetched, isNotNull);
      expect(fetched!.cardNumber, card.cardNumber);
    });

    test('Update card', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      final updated = card.copyWith(firstName: 'Jane');
      await repo.updateCard(updated);
      final fetched = await repo.getCardById(card.id);
      expect(fetched!.firstName, 'Jane');
    });

    test('Remove card', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      await repo.removeCard(card.id);
      final cards = await repo.getCards();
      expect(cards.isEmpty, true);
    });

    test('isCardExists returns correct value', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      expect(await repo.isCardExists('4000001234567890'), true);
      expect(await repo.isCardExists('9999999999999999'), false);
    });

    test('clearAllCards empties repository', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      await repo.clearAllCards();
      final cards = await repo.getCards();
      expect(cards.isEmpty, true);
    });

    test('getCardCount returns correct value', () async {
      final card1 = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      final card2 = CardModel(cardNumber: '5100001234567890', firstName: 'Jane', lastName: 'Smith', cvv: '456', expiry: '11/27', country: 'USA', city: 'LA', pin: '5678', cardType: 'Mastercard', bankName: 'Chase Bank');
      await repo.addCard(card1);
      await repo.addCard(card2);
      expect(await repo.getCardCount(), 2);
    });
  });
}
