import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../model/expense_record.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, "expense.db"),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE expense_record(id TEXT PRIMARY KEY, date TEXT, currency Text, amount REAL )");
  }, version: 1);
  return db;
}

Future<List<ExpenseRecord>> getExpenses() async {
  final db = await _getDatabase();
  final rowList = await db.query("expense_record");
  return rowList.map((row) {
    return ExpenseRecord(
        id: row['id'] as String,
        currency: row["currency"] as String,
        date: row["date"] as DateTime,
        amount: row["amount"] as String);
  }).toList();
}
