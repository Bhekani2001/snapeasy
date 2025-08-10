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
      final List<Map<String, dynamic>> maps = await db.query('cards');
      return maps.map((json) => CardModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getting cards: $e');
      return [];
    }
  }

  @override
  Future<CardModel?> getCardById(String id) async {
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

  String detectCardType(String cardNumber) {
    if (cardNumber.isEmpty) return '';
    if (cardNumber.startsWith('4')) return 'visa';
    if (cardNumber.startsWith('5')) return 'mastercard';
    if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) return 'amex';
    if (cardNumber.startsWith('6')) return 'discover';
    return '';
  }

  String _detectBankName(String cardNumber) {
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

  @override
  Future<void> addCard(CardModel card) async {
    try {
      if (await isCardExists(card.cardNumber)) {
        throw Exception('Card with this number already exists');
      }
      // Always auto-detect cardType and bankName before saving
      final detectedCardType = card.cardType ?? detectCardType(card.cardNumber);
      final detectedBankName = card.bankName ?? _detectBankName(card.cardNumber);
      final updatedCard = CardModel(
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
      await db.insert('cards', updatedCard.toJson());
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateCard(CardModel updatedCard) async {
    try {
      // Always auto-detect cardType and bankName before updating
      final detectedCardType = updatedCard.cardType ?? detectCardType(updatedCard.cardNumber);
      final detectedBankName = updatedCard.bankName ?? _detectBankName(updatedCard.cardNumber);
      final cardToUpdate = CardModel(
        id: updatedCard.id,
        firstName: updatedCard.firstName,
        lastName: updatedCard.lastName,
        cardNumber: updatedCard.cardNumber,
        cvv: updatedCard.cvv,
        expiry: updatedCard.expiry,
        country: updatedCard.country,
        city: updatedCard.city,
        pin: updatedCard.pin,
        cardType: detectedCardType,
        bankName: detectedBankName,
      );
      await db.update('cards', cardToUpdate.toJson(), where: 'id = ?', whereArgs: [updatedCard.id]);
    } catch (e) {
      debugPrint('Error updating card: $e');
      rethrow;
    }
  }
  @override
  Future<void> removeCard(String id) async {
    try {
      await db.delete('cards', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error removing card: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> isCardExists(String cardNumber) async {
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

  // No longer needed with SQLite

  @override
  Future<void> migrateOldCardsIfNeeded() async {
    // No migration needed for SQLite
    return;
  }

}