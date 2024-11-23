import 'package:flutter/cupertino.dart';

class Purchase extends ChangeNotifier {
  String id;
  String name;

  Purchase({
    required this.id,
    required this.name,
  });

  factory Purchase.fromMap(String id, Map<String, dynamic> map) {
    return Purchase(id: id, name: map['name']);
  }
}
