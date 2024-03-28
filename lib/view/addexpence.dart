// ui/add_expense_screen.dart

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_expense_app/controll/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  Int ? amount ;
  String category = '';
  String date = '';
  String description ='';
  String? id;

  // ... form fields and logic for collecting user input

  @override
  Widget build(BuildContext context) {
 var amountController = TextEditingController();
 var categoryController = TextEditingController();
 var dateController = TextEditingController();
 var descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),


 body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Form fields for amount, category, date (optional), description (optional)
 TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'amount'),
                  ),
                   const SizedBox(height: 20),
                   TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'category'),
                  ),
                   const SizedBox(height: 20),
                   TextField(
                    controller: dateController,
                    decoration: const InputDecoration(labelText: 'date'),
                  ),
                   const SizedBox(height: 20),
                   TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'deccription'),
                  ),
                   const SizedBox(height: 20),
Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                         final Classprovider = Provider.of<Expenceprovider>(context, listen: false);
                      // Classprovider.addExpense(
                      //               amountController as double,
                      //               categoryController.text,
                      //               dateController.text,
                      //               descriptionController.text,
                      //             );
                       int amount = int.tryParse(amountController.text)??0;
  String category = categoryController.text;
  String date = dateController.text;
  String description = descriptionController.text;
  // Add expense with extracted values
  Classprovider.addExpense(amount, category, date, description);
                                  Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          amountController.clear();
                          categoryController.clear();
                          dateController.clear();
                          descriptionController.clear();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
            ]
          )
        )
 )
    );
  }
}