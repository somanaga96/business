import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  int amount;
  DateTime date;
  String name;
  bool credit;
  String comments;

  Expense(
      {required this.id,
      required this.amount,
      required this.date,
      required this.name,
      required this.credit,
      required this.comments});

  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    DateTime dateTime;
    // Check if the date is a Timestamp, if so, convert it to DateTime.
    if (map['date'] is Timestamp) {
      dateTime = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      dateTime =
          map['date'] as DateTime; // If it's already DateTime, use it directly
    } else {
      // Handle the case where the date is not provided or is of an unexpected type
      dateTime = DateTime.now(); // Use the current time or handle accordingly
    }
    String com = map['comments'] ?? '';
    return Expense(
        id: id,
        amount: map['amount'],
        date: dateTime,
        name: map['name'],
        credit: map['credit'],
        comments: com);
  }

  // Ensure you provide a method to convert this model to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp here
      'name': name,
      'credit': credit,
      "comments": comments
    };
  }
}
