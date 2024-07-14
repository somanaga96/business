import 'package:business/component/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserTool extends ChangeNotifier {
  Future<List<User>> fetchAllUsersFromDB() async {
    List<User> objectList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();
    for (var doc in querySnapshot.docs) {
      User yourObject = User(
          userName: doc.data()['userName'], password: doc.data()['password']);
      objectList.add(yourObject);
    }
    notifyListeners();
    return objectList;
  }
}
