import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/view_models/card_viewmodel.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/repositories/card_repository.dart';

class MockCardRepository extends CardRepository {
  final List<CardModel> _cards = [];

  @override
  Future<List<CardModel>> getCards() async => _cards;
  @override
  Future<CardModel?> getCardById(String id) async {
    try {
      return _cards.firstWhere((c) => c.cardNumber == id);
    } catch (e) {
      return null;
    }
  }
  @override
  Future<void> addCard(CardModel card) async => _cards.add(card);
  @override
  Future<void> updateCard(CardModel card) async {
    final idx = _cards.indexWhere((c) => c.cardNumber == card.cardNumber);
    if (idx != -1) _cards[idx] = card;
  }
  @override
  Future<void> removeCard(String id) async => _cards.removeWhere((c) => c.cardNumber == id);
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
  group('CardViewModel Tests', () {
    late CardViewModel viewModel;
    late MockCardRepository repo;

    setUp(() {
      repo = MockCardRepository();
      viewModel = CardViewModel(repo);
    });

    test('addCard adds card and returns success', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      final result = await viewModel.addCard(card);
      expect(result.success, true);
      expect((await repo.getCards()).length, 1);
    });

    test('validateCard returns error for missing fields', () async {
      final card = CardModel(cardNumber: '', firstName: '', lastName: '', cvv: '', expiry: '', country: '', city: '', pin: '', cardType: '', bankName: '');
      final result = await viewModel.validateCard(card);
      expect(result.isValid, false);
      expect(result.error, isNotNull);
    });

    test('isCardExists returns correct value', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      expect(await viewModel.isCardExists('4000001234567890'), true);
      expect(await viewModel.isCardExists('9999999999999999'), false);
    });

    test('getCardCount returns correct count', () async {
      expect(await viewModel.getCardCount(), 0);
      await repo.addCard(CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America'));
      expect(await viewModel.getCardCount(), 1);
    });

    test('clearAllCards empties repository', () async {
      await repo.addCard(CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America'));
      await viewModel.clearAllCards();
      expect((await repo.getCards()).isEmpty, true);
    });
  });
}
