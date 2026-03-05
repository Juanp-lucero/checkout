import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'checkout.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cards(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            holder TEXT NOT NULL,
            number TEXT NOT NULL,
            expMonth INTEGER NOT NULL,
            expYear INTEGER NOT NULL,
            brand TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE payments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cardId INTEGER,
            amount REAL NOT NULL,
            method TEXT NOT NULL,
            promoCode TEXT,
            discount REAL NOT NULL DEFAULT 0,
            createdAt TEXT NOT NULL,
            FOREIGN KEY(cardId) REFERENCES cards(id)
          )
        ''');
      },
    );
    return _db!;
  }
}
