import 'package:sqflite/sqflite.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';

class DatabaseProvider {
  static Future<CardRepoImpl> getCardRepo() async {
    final db = await openDatabase(
      'snapeasy_cards.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cards (
            id TEXT PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            cardNumber TEXT,
            cvv TEXT,
            expiry TEXT,
            country TEXT,
            city TEXT,
            pin TEXT,
            cardType TEXT,
            bankName TEXT
          )
        ''');
      },
    );
    return CardRepoImpl(db);
  }
}
