import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:snapeasy/models/card_model.dart';
import 'card_repository.dart';

class CardRepoImpl implements CardRepository {
  final Database db;

  CardRepoImpl(this.db);

  @override
  Future<List<CardModel>> getCards() async {
    try {
      final maps = await db.query('cards');
      return maps.map(CardModel.fromJson).toList();
    } catch (e) {
      debugPrint('Error getting cards: $e');
      return [];
    }
  }

  @override
  Future<CardModel?> getCardById(String id) async {
    if (id.isEmpty) return null;
    try {
      final maps = await db.query('cards', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return CardModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting card by ID: $e');
      return null;
    }
  }

  @override
  Future<void> addCard(CardModel card) async {
    if (card.cardNumber.isEmpty) throw ArgumentError('Card number cannot be empty');
    if (await isCardExists(card.cardNumber)) {
      throw Exception('Card with this number already exists');
    }
    final updatedCard = _withDetectedFields(card);
    try {
      await db.insert('cards', updatedCard.toJson());
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateCard(CardModel card) async {
    if (card.id.isEmpty) throw ArgumentError('Card ID cannot be empty');
    final updatedCard = _withDetectedFields(card);
    try {
      await db.update('cards', updatedCard.toJson(), where: 'id = ?', whereArgs: [card.id]);
    } catch (e) {
      debugPrint('Error updating card: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeCard(String id) async {
    if (id.isEmpty) throw ArgumentError('Card ID cannot be empty');
    try {
      await db.delete('cards', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error removing card: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isCardExists(String cardNumber) async {
    if (cardNumber.isEmpty) return false;
    try {
      final maps = await db.query('cards', where: 'cardNumber = ?', whereArgs: [cardNumber]);
      return maps.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking card existence: $e');
      return false;
    }
  }

  @override
  Future<void> clearAllCards() async {
    try {
      await db.delete('cards');
    } catch (e) {
      debugPrint('Error clearing all cards: $e');
      rethrow;
    }
  }

  @override
  Future<int> getCardCount() async {
    try {
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cards'));
      return count ?? 0;
    } catch (e) {
      debugPrint('Error getting card count: $e');
      return 0;
    }
  }

  @override
  Future<void> migrateOldCardsIfNeeded() async {
    return;
  }

  static String detectCardType(String cardNumber) {
    if (cardNumber.isEmpty) return '';
    if (cardNumber.startsWith('4')) return 'visa';
    if (cardNumber.startsWith('5')) return 'mastercard';
    if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) return 'amex';
    if (cardNumber.startsWith('6')) return 'discover';
    return '';
  }

  static String detectBankName(String cardNumber) {
    if (cardNumber.isEmpty || cardNumber.length < 6) return 'Unknown Bank';
    final bin = cardNumber.substring(0, 6);
    switch (bin) {
      case '400000': return 'Bank of America';
      case '510000': return 'Chase Bank';
      case '340000': return 'American Express Bank';
      case '601100': return 'Discover Bank';
      default: return 'Unknown Bank';
    }
  }

  CardModel _withDetectedFields(CardModel card) {
    final detectedCardType = card.cardType ?? detectCardType(card.cardNumber);
    final detectedBankName = card.bankName ?? detectBankName(card.cardNumber);
    return CardModel(
      id: card.id,
      firstName: card.firstName,
      lastName: card.lastName,
      cardNumber: card.cardNumber,
      cvv: card.cvv,
      expiry: card.expiry,
      country: card.country,
      city: card.city,
      pin: card.pin,
      cardType: detectedCardType,
      bankName: detectedBankName,
    );
  }
}