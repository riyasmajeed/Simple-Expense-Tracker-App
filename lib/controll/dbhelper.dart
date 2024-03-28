import 'dart:async';
import 'package:simple_expense_app/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Database? _db;

  DatabaseHelper._internal();

  static const _dbName = 'expenses.db';
  static const _dbVersion = 1;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDatabase();
    }
    return _db!;
  }
  


  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    // Create database if it doesn't exist
    final db = await openDatabase(path,
        version: _dbVersion, onCreate: (Database db, int version) async {
      final sql = '''
        CREATE TABLE expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          date TEXT,
          description TEXT
        )
      ''';
      await db.execute(sql);
    });

    return db;
  }


 Future<int> insertExpense(Expense expense) async {
    final dbClient = await db;
    return await dbClient.insert('expenses', expense.toMap());
  }

 Future<Expense?> getExpense(int id) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<int> updateExpense(Expense expense) async {
    final dbClient = await db;
    return await dbClient.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }



 Future<int> deleteExpense(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // CRUD operations implemented below
//  Future<int> calculateTotalAmount() async {
//     final dbClient = await db;
//     final List<Map<String, dynamic>> result = await dbClient.rawQuery('SELECT SUM(amount) AS total FROM expenses');
//     int totalAmount = result[0]['total'].round();
    
//     return totalAmount;
//   }
Future<int> calculateTotalAmount() async {
  final dbClient = await db;
  final List<Map<String, dynamic>> result =
      await dbClient.rawQuery('SELECT SUM(amount) AS total FROM expenses');

  // Check if result is not null and has at least one row
  if (result.isNotEmpty && result[0]['total'] != null) {
    double totalAmount = result[0]['total'] as double;
    return totalAmount.round();
  } else {
    // If result is null or empty, return 0
    return 0;
  }
}


}
