import 'package:flutter/cupertino.dart';

class Products extends ChangeNotifier {
  String id;
  String name;

  Products({
    required this.id,
    required this.name,
  });

  factory Products.fromMap(String id, Map<String, dynamic> map) {
    return Products(id: id, name: map['name']);
  }
}
