import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  String id;
  int price;
  DateTime date;
  String name;
  bool credit;

  Transactions({
    required this.id,
    required this.price,
    required this.date,
    required this.name,
    required this.credit,
  });

  factory Transactions.fromMap(String id, Map<String, dynamic> map) {
    // If date is already a DateTime, no need to convert it.
    // Otherwise, convert the Timestamp to DateTime.
    DateTime dateTime = map['date'] is Timestamp
        ? (map['date'] as Timestamp).toDate()
        : map['date']; // Handle DateTime if it's already DateTime

    return Transactions(
      id: id,
      price: map['price'],
      date: dateTime,
      name: map['name'],
      credit: map['credit'],
    );
  }

  // Ensure you provide a method to convert this model to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp here
      'name': name,
      'credit': credit,
    };
  }
}
