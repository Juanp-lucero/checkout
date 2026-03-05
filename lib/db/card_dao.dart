import 'package:sqflite/sqflite.dart';

import '../models/card_model.dart';
import 'app_database.dart';

class CardDao {
  static const table = 'cards';

  Future<int> insert(BankCard card) async {
    final db = await AppDatabase.instance();
    return db.insert(table, card.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BankCard>> all() async {
    final db = await AppDatabase.instance();
    final rows = await db.query(table, orderBy: 'id DESC');
    return rows.map((m) => BankCard.fromMap(m)).toList();
  }
}
