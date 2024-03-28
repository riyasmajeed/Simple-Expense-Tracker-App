import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_expense_app/controll/provider.dart';
import 'package:simple_expense_app/model/model.dart';
import 'package:simple_expense_app/view/addexpence.dart';
import 'package:simple_expense_app/view/update.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  int budgetAmount = 500;

  @override
  void initState() {
    super.initState();
    // Fetch expenses on app launch
    Provider.of<Expenceprovider>(context, listen: false).getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<Expenceprovider>(context);
    final List<Expense> expenses = expensesProvider.expenses;
    final int totalAmount = expensesProvider.totalAmount;

    // Check if total amount exceeds budget amount
    if (totalAmount >= budgetAmount) {
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Budget Reached'),
            content: Text('Total expenses have reached or exceeded the budget amount.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
log('hi');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home, color: Colors.white)),
              Tab(icon: Icon(Icons.money, color: Colors.white)),
            ],
          ),
          centerTitle: true,
          title: Text('Expense Tracker'),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.blue,
                  child: Text('Total Expenses: $totalAmount'),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.cyan,
                  child: Text("Monthly Budget: $budgetAmount"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    title: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("amount :${expense.amount}"),
                          Text("category :${expense.category}"),
                          Text("date :${expense.date}"),
                          Text("description :${expense.description}"),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            expensesProvider.deleteExpense(expense.id);

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.update),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateExpenseScreen(expense: expense),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
