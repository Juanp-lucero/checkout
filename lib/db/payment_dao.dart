import 'package:sqflite/sqflite.dart';

import '../models/payment_model.dart';
import 'app_database.dart';

class PaymentDao {
  static const table = 'payments';

  Future<int> insert(Payment p) async {
    final db = await AppDatabase.instance();
    return db.insert(table, p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Payment>> all() async {
    final db = await AppDatabase.instance();
    final rows = await db.query(table, orderBy: 'createdAt DESC');
    return rows.map((m) => Payment.fromMap(m)).toList();
  }
}
