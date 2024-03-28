import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_expense_app/controll/provider.dart';
import 'package:simple_expense_app/model/model.dart';

class UpdateExpenseScreen extends StatefulWidget {
  final Expense expense;

  const UpdateExpenseScreen({Key? key, required this.expense}) : super(key: key);

  @override
  _UpdateExpenseScreenState createState() => _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends State<UpdateExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _categoryController = TextEditingController(text: widget.expense.category);
    _dateController = TextEditingController(text: widget.expense.date );
    _descriptionController = TextEditingController(text: widget.expense.description );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final expenseProvider = Provider.of<Expenceprovider>(context, listen: false);
                    int amount = int.parse(_amountController.text);
                    String category = _categoryController.text;
                    String date = _dateController.text;
                    String description = _descriptionController.text;
                    // Update expense with extracted values
                    Expense updatedExpense = Expense(
                      id: widget.expense.id,
                      amount: amount,
                      category: category,
                      date:  date ,
                      description: description,
                    );
                    expenseProvider.updateExpense(updatedExpense);
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
