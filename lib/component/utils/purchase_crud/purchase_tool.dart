import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../entity/purchase.dart';

class ProductTool extends ChangeNotifier {
  Future<List<Product>> fetchProductProductsFromDB() async {
    List<Product> objectList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('expense').get();
      for (var doc in querySnapshot.docs) {
        Product product = Product.fromMap(doc.id, doc.data());
        objectList.add(product);
      }
    } catch (e) {
      print('Error fetching data from fetchProductProductsFromDB: $e');
    }
    notifyListeners();
    return objectList;
  }
}
