import 'package:snapeasy/models/card_model.dart';

abstract class CardRepository {
  Future<List<CardModel>> getCards();
  Future<CardModel?> getCardById(String id);
  Future<void> addCard(CardModel card);
  Future<void> updateCard(CardModel card);
  Future<void> removeCard(String id);
  Future<bool> isCardExists(String cardNumber);
  Future<void> clearAllCards();
  Future<int> getCardCount();
  Future<void> migrateOldCardsIfNeeded();
}