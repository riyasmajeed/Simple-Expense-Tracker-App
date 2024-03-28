class Expense {
  final int id;
  final int amount;
  final String category;
  final String date;
  final String description;
  

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    // Convert double to int for amount
    int amountValue = map['amount'] is int? map['amount'] : map['amount'].toInt();
    return Expense(
      id: map['id'] as int? ??0,
      amount: amountValue,
      category: map['category'] as String,
      date: map['date'] as String? ??'',
      description: map['description'] as String? ??'',
    );
  }
}
