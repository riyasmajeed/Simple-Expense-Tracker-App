import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:simple_expense_app/controll/dbhelper.dart';
import 'package:simple_expense_app/model/model.dart';


class Expenceprovider with ChangeNotifier {
  final dbHelper = DatabaseHelper();
  List<Expense> _expenses = [];
  int _totalAmount = 0;

  List<Expense> get expenses => _expenses;
int get totalAmount => _totalAmount;
 

  Future<void> getExpenses() async {
    final db = await dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    _expenses = maps.map((map) => Expense.fromMap(map)).toList();
     _totalAmount = await dbHelper.calculateTotalAmount();
    notifyListeners();
  }

  Future<void> addExpense(int amount, String category, String date, String description) async {
    final db = await dbHelper.db;
    final result = await db.insert('expenses', {
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
    });
    final id = result;
    final newExpense = Expense(
      id: id,
      amount: amount,
      category: category,
      date: date,
      description: description,
    );
 _expenses.add(newExpense);
 _totalAmount += amount;
    notifyListeners();
    

  }

   Future<void> updateExpense(Expense expense) async {
    final db = await dbHelper.db;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );

    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
  _totalAmount -= _expenses[index].amount; // Subtract old amount
      _totalAmount += expense.amount; // Add new amount

      _expenses[index] = expense;
      notifyListeners();
    }
  }



  Future<void> deleteExpense(int id) async {
    final db = await dbHelper.db;
      final deletedExpense = _expenses.firstWhere((expense) => expense.id == id);
  final deletedAmount = deletedExpense.amount;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    _expenses.removeWhere((expense) => expense.id == id);
    _totalAmount -= deletedAmount; // Subtract deleted amount
    notifyListeners();
  }


  void _calculateTotalAmount() {
    _totalAmount = 0;
    for (var expense in _expenses) {
      _totalAmount += expense.amount;
    }
    
  }
 
}