import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  int amount;
  DateTime date;
  String name;

  Expense(
      {required this.id,
      required this.amount,
      required this.date,
      required this.name});

  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    DateTime dateTime = map['date'] is Timestamp
        ? (map['date'] as Timestamp).toDate()
        : map['date'];

    return Expense(
      id: id,
      amount: map['amount'],
      date: dateTime,
      name: map['name'],
    );
  }

  // Ensure you provide a method to convert this model to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp here
      'name': name,
    };
  }
}
