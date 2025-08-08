import 'package:snapeasy/models/card_model.dart';
import 'package:snapeasy/repositories/card_repository.dart';

class CardViewModel {
  final CardRepository repository;

  CardViewModel(this.repository);

  Future<void> initialize() async {
    await repository.migrateOldCardsIfNeeded();
  }

  Future<({bool success, String? error})> addCard(CardModel card) async {
    try {
      if (await repository.isCardExists(card.cardNumber)) {
        return (success: false, error: 'Card with this number already exists');
      }
      await repository.addCard(card);
      return (success: true, error: null);
    } catch (e) {
      return (success: false, error: 'Failed to add card: ${e.toString()}');
    }
  }

  Future<List<CardModel>> getCards() async {
    try {
      return await repository.getCards();
    } catch (e) {
      throw Exception('Failed to load cards: ${e.toString()}');
    }
  }

  Future<CardModel?> getCardById(String id) async {
    try {
      return await repository.getCardById(id);
    } catch (e) {
      throw Exception('Failed to get card: ${e.toString()}');
    }
  }

  Future<({bool success, String? error})> updateCard(CardModel card) async {
    try {
      await repository.updateCard(card);
      return (success: true, error: null);
    } catch (e) {
      return (success: false, error: 'Failed to update card: ${e.toString()}');
    }
  }

  Future<bool> removeCard(String id) async {
    try {
      await repository.removeCard(id);
      return true;
    } catch (e) {
      throw Exception('Failed to remove card: ${e.toString()}');
    }
  }

  Future<bool> isCardExists(String cardNumber) async {
    try {
      return await repository.isCardExists(cardNumber);
    } catch (e) {
      throw Exception('Failed to check card existence: ${e.toString()}');
    }
  }


  Future<int> getCardCount() async {
    try {
      return await repository.getCardCount();
    } catch (e) {
      throw Exception('Failed to get card count: ${e.toString()}');
    }
  }

  Future<void> clearAllCards() async {
    try {
      await repository.clearAllCards();
    } catch (e) {
      throw Exception('Failed to clear cards: ${e.toString()}');
    }
  }

  Future<List<CardModel>> getCardsByCountry(String country) async {
    try {
      final cards = await repository.getCards();
      return cards.where((card) => card.country == country).toList();
    } catch (e) {
      throw Exception('Failed to filter cards: ${e.toString()}');
    }
  }


  Future<({bool isValid, String? error})> validateCard(CardModel card) async {
    if (card.cardNumber.isEmpty) {
      return (isValid: false, error: 'Card number is required');
    }
    if (card.cvv.isEmpty) {
      return (isValid: false, error: 'CVV is required');
    }
    if (card.expiry.isEmpty) {
      return (isValid: false, error: 'Expiry date is required');
    }
    if (card.country.isEmpty) {
      return (isValid: false, error: 'Country is required');
    }
    return (isValid: true, error: null);
  }
}