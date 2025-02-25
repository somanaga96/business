import 'package:business/component/entity/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/global.dart';

class UserCrud extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createOrUpdateUser(
    BuildContext context, {
    String? existingDocId,
  }) async {
    // If existingDocId is provided, fetch the existing user data
    if (existingDocId != null) {
      var docSnapshot = await user.doc(existingDocId).get();
      if (docSnapshot.exists) {
        var userData = docSnapshot.data() as Map<String, dynamic>;
        nameController.text = userData['name'] ?? '';
      }
    }

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext modalContext, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Add or Edit a Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: 'பெயர்', hintText: 'பெயர் '),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields!'),
                              ),
                            );
                            return;
                          }

                          if (existingDocId == null) {
                            await user.add({
                              'name': nameController.text,
                            });
                          } else {
                            await user.doc(existingDocId).update({
                              'name': nameController.text,
                            });
                          }

                          // Clear controllers after saving
                          nameController.text = '';
                          Navigator.pop(ctx);

                          // Refresh customer list
                          Provider.of<Global>(context, listen: false)
                              .fetchCustomerList();
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteUser(String docId) async {
    try {
      await user.doc(docId).delete();
    } catch (e) {
      print('Error deleting User: $e');
    }
  }

  Future<List<Users>> fetchUserList() async {
    List<Users> objectList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('user').get();

      // Check if there are documents in the querySnapshot
      print('Number of user fetched: ${querySnapshot.docs.length}');

      for (var doc in querySnapshot.docs) {
        // Create the Debt object
        Users yourObject = Users(id: doc.id, name: doc.data()['name']);
        objectList.add(yourObject);
      }

      // Notify listeners to update the UI
      notifyListeners();

      // Print the entire list
      print('Final User list: $objectList');
      return objectList;
    } catch (e) {
      // Print any errors for debugging
      print('Error fetching user transactions: $e');
      return [];
    }
  }


}
