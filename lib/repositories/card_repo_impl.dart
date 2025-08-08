import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapeasy/models/card_model.dart';
import 'dart:convert';
import 'card_repository.dart';

class CardRepoImpl implements CardRepository {
  final SharedPreferences prefs;
  static const String _cardsKey = 'cards';

  CardRepoImpl(this.prefs);

  @override
  Future<List<CardModel>> getCards() async {
    try {
      final cardsString = prefs.getString(_cardsKey);
      if (cardsString == null || cardsString.isEmpty) return [];
      
      final List<dynamic> cardsJson = json.decode(cardsString);
      return cardsJson.map((json) => CardModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getting cards: $e');
      return [];
    }
  }

  @override
  Future<CardModel?> getCardById(String id) async {
    try {
      final cards = await getCards();
      return cards.firstWhere((card) => card.id == id);
    } on StateError {
      return null; // Card not found
    } catch (e) {
      debugPrint('Error getting card by ID: $e');
      return null;
    }
  }

  @override
  Future<void> addCard(CardModel card) async {
    try {
      if (await isCardExists(card.cardNumber)) {
        throw Exception('Card with this number already exists');
      }
      
      final cards = await getCards();
      cards.add(card);
      await _saveAllCards(cards);
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateCard(CardModel updatedCard) async {
    try {
      final cards = await getCards();
      final index = cards.indexWhere((c) => c.id == updatedCard.id);
      
      if (index == -1) {
        throw Exception('Card not found');
      }
      
      // Check if another card already has this number
      final existingCard = cards.firstWhere(
        (c) => c.cardNumber == updatedCard.cardNumber && c.id != updatedCard.id,
        orElse: () => CardModel.empty(),
      );
      
      if (existingCard.id.isNotEmpty) {
        throw Exception('Another card already uses this number');
      }
      
      cards[index] = updatedCard;
      await _saveAllCards(cards);
    } catch (e) {
      debugPrint('Error updating card: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeCard(String id) async {
    try {
      final cards = await getCards();
      cards.removeWhere((c) => c.id == id);
      await _saveAllCards(cards);
    } catch (e) {
      debugPrint('Error removing card: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> isCardExists(String cardNumber) async {
    try {
      final cards = await getCards();
      return cards.any((card) => card.cardNumber == cardNumber);
    } catch (e) {
      debugPrint('Error checking card existence: $e');
      return false;
    }
  }

  @override
  Future<void> clearAllCards() async {
    try {
      await prefs.remove(_cardsKey);
    } catch (e) {
      debugPrint('Error clearing all cards: $e');
      rethrow;
    }
  }

  @override
  Future<int> getCardCount() async {
    try {
      final cards = await getCards();
      return cards.length;
    } catch (e) {
      debugPrint('Error getting card count: $e');
      return 0;
    }
  }

  Future<void> _saveAllCards(List<CardModel> cards) async {
    try {
      final cardsJson = cards.map((c) => c.toJson()).toList();
      await prefs.setString(_cardsKey, json.encode(cardsJson));
    } catch (e) {
      debugPrint('Error saving cards: $e');
      rethrow;
    }
  }

  @override
  Future<void> migrateOldCardsIfNeeded() async {
    try {
      final cards = await getCards();
      if (cards.isNotEmpty && cards.any((c) => c.id.isEmpty)) {
        final migratedCards = cards.map((c) => c.id.isEmpty 
            ? CardModel(
                id: CardModel.generateId(),
                firstName: c.firstName,
                lastName: c.lastName,
                cardNumber: c.cardNumber,
                cvv: c.cvv,
                expiry: c.expiry,
                country: c.country,
                city: c.city,
              )
            : c).toList();
        
        await _saveAllCards(migratedCards);
      }
    } catch (e) {
      debugPrint('Error migrating cards: $e');
    }
  }
}