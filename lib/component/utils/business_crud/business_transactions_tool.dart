import 'package:business/component/entity/transaction.dart';
import 'package:business/component/utils/business_crud/purchase_income_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class BusinessTransactionsTool extends ChangeNotifier {
  Future<String> fetchAllMonthDebitFromDB(DateTime date) async {
    List<Transactions> objectList = [];
    int totalPrice = 0;

    try {
      // Get the first day of the month
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      // Fetch the data within the current month range
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transanction')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .where('credit', isEqualTo: false)
              .orderBy('date', descending: true)
              .get();

      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Transactions yourObject = Transactions.fromMap(doc.id, doc.data());
        objectList.add(yourObject);

        // Add the price to the total price
        totalPrice += yourObject.price;
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.
    return totalPrice.toString();
  }

  Future<String> fetchAllMonthCreditFromDB(DateTime date) async {
    List<Transactions> objectList = [];
    int totalPrice = 0; // Initialize total price variable

    try {
      // Get the first day of the month
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      // Fetch the data within the current month range
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transanction')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .where('credit', isEqualTo: true)
              .orderBy('date', descending: true)
              .get();

      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Transactions yourObject = Transactions.fromMap(doc.id, doc.data());
        objectList.add(yourObject);

        // Add the price to the total price
        totalPrice += yourObject.price;
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.

    // Return both the objectList and the totalPrice
    return totalPrice.toString();
  }

  Future<List<Transactions>> fetchCurrentMonthPurchaseFromDB(
      DateTime date) async {
    List<Transactions> objectList = [];

    try {
      // Get the first day of the month
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      // Fetch the data within the current month range
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transanction')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: true)
              .get();

      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Transactions yourObject = Transactions.fromMap(doc.id, doc.data());
        objectList.add(yourObject);
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.
    return objectList;
  }

  Future<List<Transactions>> fetchCurrentMonthUserPurchaseFromDB(
      String name, DateTime date) async {
    List<Transactions> objectList = [];

    try {
      // Get the first day of the month
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      // Fetch the data within the current month range
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transanction')
              .where('name', isEqualTo: name)
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: true)
              .get();

      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Transactions yourObject = Transactions.fromMap(doc.id, doc.data());
        objectList.add(yourObject);
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.
    return objectList;
  }

  Future<String> purchaseProductTotal(String name, DateTime date) async {
    int totalPrice = 0;

    try {
      // Get the first day of the month
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      // Fetch the data within the current month range
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transanction')
              .where('name', isEqualTo: name)
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: true)
              .get();
      for (var doc in querySnapshot.docs) {
        Transactions yourObject = Transactions.fromMap(doc.id, doc.data());
        // Add the price to the total price
        totalPrice += yourObject.price;
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.

    // Return both the objectList and the totalPrice
    return totalPrice.toString();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime dateTime = DateTime.now();
  String name = "";
  int dayOfMonth = DateTime.now().day;
  final CollectionReference transactions =
      FirebaseFirestore.instance.collection('transanction');
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products'); // Reference for products

  FirebaseFirestore db = FirebaseFirestore.instance;
  final List _tenureTypes = ["வரவு", "செலவு"];
  String _tenureType = "வரவு";
  bool _switchValue = false;

// Function to fetch products from Firestore
  Future<List<String>> fetchProducts() async {
    QuerySnapshot snapshot = await productsCollection.get();
    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  Future<void> createTransaction(BuildContext context) async {
    List<String> list = await fetchProducts();
    String dropdownValue = list.isNotEmpty ? list.first : '';

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
                    'Add a Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue.isNotEmpty ? dropdownValue : null,
                    hint: const Text('தேர்ந்தெடுக்கவும்'),
                    icon: const Icon(Icons.search),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      if (value != null) {
                        modalSetState(() {
                          dropdownValue = value;
                        });
                      }
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      labelText: 'விலை',
                      hintText: 'பொருளின் விலை',
                    ),
                  ),
                  PeriodInput(
                    tenureType: _tenureType,
                    switchValue: _switchValue,
                    onSwitchChanged: (value) {
                      modalSetState(() {
                        _tenureType = value ? _tenureTypes[1] : _tenureTypes[0];
                        _switchValue = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    child:
                        Text(DateFormat().addPattern('d/M/y').format(dateTime)),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: modalContext,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now(),
                      );
                      if (newDate != null) {
                        modalSetState(() => dateTime = newDate);
                      }
                    },
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
                          if (amountController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Amount cannot be empty!')),
                            );
                            return;
                          }

                          final int? num = int.tryParse(amountController.text);
                          if (num == null || num < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a valid amount!')),
                            );
                            return;
                          }

                          if (dropdownValue.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please select a valid item!')),
                            );
                            return;
                          }

                          await transactions.add({
                            'name': dropdownValue,
                            'price': num,
                            'date': dateTime,
                            'credit': _tenureType == _tenureTypes[0],
                          });

                          nameController.clear();
                          amountController.clear();
                          dateTime = DateTime.now();
                          Navigator.pop(ctx);

                          Provider.of<Global>(context, listen: false)
                              .getTransactionsDetails();
                          Provider.of<Global>(context, listen: false)
                              .getDebitTransactions();
                          Provider.of<Global>(context, listen: false)
                              .getCreditTransactions();
                        },
                        child: const Text(
                          "Add",
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

  Future<void> deleteTransaction(
      bool mounted, BuildContext context, String docId) async {
    try {
      await transactions.doc(docId).delete();

      // Ensure widget is still mounted before accessing context or calling Provider
      if (!mounted) return;

      // Delay the execution to ensure widget is mounted
      Future.microtask(() {
        if (!mounted) return;

        Provider.of<Global>(context, listen: false).getTransactionsDetails();
        Provider.of<Global>(context, listen: false).getDebitTransactions();
        Provider.of<Global>(context, listen: false).getCreditTransactions();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully!')),
        );
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete transaction: $e')),
      );
    }
  }

  Future<void> updateTransaction(bool mounted, BuildContext context,
      String docId, Map<String, dynamic> currentData) async {
    final TextEditingController updateAmountController =
        TextEditingController(text: currentData['price'].toString());
    String dropdownValue = currentData['name'];
    bool currentSwitchValue = currentData['credit'];

    DateTime currentDateTime = (currentData['date'] is Timestamp)
        ? (currentData['date'] as Timestamp).toDate()
        : currentData['date'];

    // Fetch product list before opening the modal
    List<String> productList = await fetchProducts();

    if (productList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No products available to select.')),
      );
      return;
    }

    if (!productList.contains(dropdownValue)) {
      dropdownValue =
          productList.first; // Set default if current value is missing
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
                    'Update Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.search),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline:
                        Container(height: 2, color: Colors.deepPurpleAccent),
                    onChanged: (String? value) {
                      if (value != null) {
                        modalSetState(() {
                          dropdownValue = value;
                        });
                      }
                    },
                    items: productList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: updateAmountController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      labelText: 'விலை',
                      hintText: 'பொருளின் விலை',
                    ),
                  ),
                  PeriodInput(
                    tenureType: currentSwitchValue ? "வரவு" : "செலவு",
                    switchValue: currentSwitchValue,
                    onSwitchChanged: (value) {
                      modalSetState(() {
                        currentSwitchValue = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text(DateFormat()
                        .addPattern('d/M/y')
                        .format(currentDateTime)),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: modalContext,
                        initialDate: currentDateTime,
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now(),
                      );
                      if (newDate != null) {
                        modalSetState(() => currentDateTime = newDate);
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final int? updatedPrice =
                              int.tryParse(updateAmountController.text);
                          if (updatedPrice == null || updatedPrice < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a valid amount!')),
                            );
                            return;
                          }

                          Timestamp updatedTimestamp =
                              Timestamp.fromDate(currentDateTime);

                          if (!mounted) return;

                          await transactions.doc(docId).update({
                            'name': dropdownValue,
                            'price': updatedPrice,
                            'date': updatedTimestamp,
                            'credit': currentSwitchValue,
                          });

                          Navigator.pop(ctx);

                          if (!mounted) return;
                          Provider.of<Global>(context, listen: false)
                              .getTransactionsDetails();
                          Provider.of<Global>(context, listen: false)
                              .getDebitTransactions();
                          Provider.of<Global>(context, listen: false)
                              .getCreditTransactions();
                        },
                        child: const Text("Update",
                            style: TextStyle(color: Colors.green)),
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
}
