import 'package:flutter/cupertino.dart';

class Product extends ChangeNotifier {
  String id;
  String name;

  Product({
    required this.id,
    required this.name,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(id: id, name: map['name']);
  }
}
