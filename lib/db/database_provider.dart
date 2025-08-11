import 'package:sqflite/sqflite.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';

class DatabaseProvider {
  static Database? _db;
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    try {
      return await openDatabase(
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
    } catch (e) {
      throw Exception('Database initialization failed: $e');
    }
  }

  Future<CardRepoImpl> getCardRepo() async {
    final db = await database;
    return CardRepoImpl(db);
  }
}
