import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';
import 'package:snapeasy/models/card_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('CardRepoImpl Tests', () {
    late CardRepoImpl repo;
    setUp(() async {
      final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      repo = CardRepoImpl(db);
      await repo.clearAllCards();
    });

    test('Add and get card', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      final cards = await repo.getCards();
      expect(cards.length, 1);
      expect(cards.first.cardNumber, '4000001234567890');
    });

    test('Remove card', () async {
      final card = CardModel(cardNumber: '4000001234567890', firstName: 'John', lastName: 'Doe', cvv: '123', expiry: '12/28', country: 'USA', city: 'NY', pin: '1234', cardType: 'Visa', bankName: 'Bank of America');
      await repo.addCard(card);
      await repo.removeCard(card.cardNumber);
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
  });
}
