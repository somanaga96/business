import 'package:business/component/entity/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../business_crud/purchase_income_input.dart';
import '../global.dart';

class ExpenseTransactionsTool extends ChangeNotifier {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user');

  // Function to fetch users from Firestore
  Future<List<String>> fetchUsers() async {
    QuerySnapshot snapshot = await usersCollection.get();
    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  // Function to fetch products from Firestore
  Future<List<String>> fetchProducts() async {
    QuerySnapshot snapshot = await productsCollection.get();
    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  Future<void> createExpenseTransaction(BuildContext context) async {
    List<String> userList = await fetchUsers();
    List<String> productList = await fetchProducts();

    final TextEditingController amountController = TextEditingController();
    String userDropdownValue = 'பெயர் தேர்ந்தெடுக்கவும்';
    userList.insert(0, userDropdownValue);

    String productDropdownValue = 'பொருள் தேர்ந்தெடுக்கவும்';
    productList.insert(0, productDropdownValue);

    bool currentSwitchValue = false;
    DateTime selectedDate = DateTime.now();

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        // Ensure modalContext is not null
        if (modalContext == null) {
          return Container();
        }

        return Builder(
          builder: (BuildContext innerContext) {
            // Ensure innerContext is not null
            if (innerContext == null) {
              return Container();
            }

            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(innerContext).viewInsets.bottom + 20,
              ),
              child: StatefulBuilder(
                builder:
                    (BuildContext modalContext, StateSetter modalSetState) {
                  return Container(
                    width: MediaQuery.of(innerContext).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Create Expense',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // User Dropdown
                        DropdownButton<String>(
                          value: userDropdownValue,
                          onChanged: (String? value) {
                            if (value != null) {
                              modalSetState(() {
                                userDropdownValue = value;
                              });
                            }
                          },
                          items: userList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        ),
                        // Product Dropdown
                        DropdownButton<String>(
                          value: productDropdownValue,
                          onChanged: (String? value) {
                            if (value != null) {
                              modalSetState(() {
                                productDropdownValue = value;
                              });
                            }
                          },
                          items: productList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        ),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          // keyboardType: TextInputType.number,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Amount', hintText: 'Enter amount'),
                        ),
                        PeriodInput(
                          tenureType: currentSwitchValue ? "Credit" : "Debit",
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
                              .format(selectedDate)),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: innerContext,
                              initialDate: selectedDate,
                              firstDate: DateTime(2022),
                              lastDate: DateTime.now(),
                            );

                            if (newDate != null) {
                              modalSetState(() => selectedDate = newDate);
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(innerContext),
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.red)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final int? amount =
                                    int.tryParse(amountController.text);
                                if (amount == null || amount <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please enter a valid amount')));
                                  return;
                                }

                                Timestamp timestamp =
                                    Timestamp.fromDate(selectedDate);
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('expense')
                                      .add({
                                    'name': userDropdownValue,
                                    "comments": productDropdownValue,
                                    'amount': amount,
                                    'date': timestamp,
                                    'credit': currentSwitchValue,
                                  });

                                  Navigator.pop(innerContext);
                                  Provider.of<Global>(context, listen: false)
                                      .getCurrentMonthExpenseTransaction();
                                } catch (e) {
                                  print('Error creating expense: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to create expense')));
                                }
                              },
                              child: Text("Create",
                                  style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // Fetch current month's expenses list from the database
  Future<List<Expense>> fetchCurrentMonthExpenseFromDB(DateTime date) async {
    List<Expense> objectList = [];

    try {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('expense')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: true)
              .get();

      for (var doc in querySnapshot.docs) {
        Expense expense = Expense.fromMap(doc.id, doc.data());
        objectList.add(expense);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    notifyListeners();
    return objectList;
  }

  Future<void> updateExpense(bool mounted, BuildContext context,
      String expenseId, Map<String, dynamic> currentData) async {
    List<String> userList = await fetchUsers();
    List<String> productList = await fetchProducts();

    final TextEditingController updateAmountController =
        TextEditingController(text: currentData['amount']?.toString() ?? "");

    // Handle null or missing 'name' field
    String userDropdownValue =
        (currentData['name'] != null && userList.contains(currentData['name']))
            ? currentData['name']
            : 'பெயர் தேர்ந்தெடுக்கவும்';
    if (!userList.contains(userDropdownValue)) {
      userList.insert(0, userDropdownValue);
    }

    // Handle null or missing 'comments' field
    String productDropdownValue = (currentData['comments'] != null &&
            productList.contains(currentData['comments']))
        ? currentData['comments']
        : 'product தேர்ந்தெடுக்கவும்';
    if (!productList.contains(productDropdownValue)) {
      productList.insert(0, productDropdownValue);
    }

    bool currentSwitchValue = currentData['credit'] ?? false;
    DateTime currentDateTime = (currentData['date'] is Timestamp)
        ? (currentData['date'] as Timestamp).toDate()
        : DateTime.now(); // Use current date if missing

    if (mounted) {
      await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext modalContext) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
            ),
            child: StatefulBuilder(
              builder: (BuildContext modalContext, StateSetter modalSetState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Update Expense',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),

                    // User Dropdown
                    DropdownButton<String>(
                      value: userDropdownValue,
                      onChanged: (String? value) {
                        if (value != null) {
                          modalSetState(() {
                            userDropdownValue = value;
                          });
                        }
                      },
                      items: userList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                    ),

                    // Product Dropdown
                    DropdownButton<String>(
                      value: productDropdownValue,
                      onChanged: (String? value) {
                        if (value != null) {
                          modalSetState(() {
                            productDropdownValue = value;
                          });
                        }
                      },
                      items: productList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                    ),

                    TextField(
                      controller: updateAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Amount', hintText: 'Enter amount'),
                    ),

                    PeriodInput(
                      tenureType: currentSwitchValue ? "Credit" : "Debit",
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
                          onPressed: () => Navigator.pop(modalContext),
                          child: Text("Cancel",
                              style: TextStyle(color: Colors.red)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final int? updatedPrice =
                                int.tryParse(updateAmountController.text);
                            if (updatedPrice == null || updatedPrice <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please enter a valid amount')));
                              return;
                            }

                            Timestamp updatedTimestamp =
                                Timestamp.fromDate(currentDateTime);

                            try {
                              await FirebaseFirestore.instance
                                  .collection('expense')
                                  .doc(expenseId)
                                  .update({
                                'name': userDropdownValue,
                                'comments': productDropdownValue,
                                'amount': updatedPrice,
                                'date': updatedTimestamp,
                                'credit': currentSwitchValue,
                              });

                              Navigator.pop(modalContext);
                              Provider.of<Global>(context, listen: false)
                                  .getCurrentMonthExpenseTransaction();
                            } catch (e) {
                              print('Error updating expense: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to update expense')));
                            }
                          },
                          child: Text("Update",
                              style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

  // Delete an expense from Firestore
  Future<void> deleteExpense(BuildContext context, String expenseId) async {
    try {
      await FirebaseFirestore.instance
          .collection('expense')
          .doc(expenseId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted successfully!')),
      );
      notifyListeners();
    } catch (e) {
      print("Error deleting expense: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete expense')),
      );
    }
  }

  Future<String> fetchCurrentMonthGivenSum(DateTime date) async {
    List<Expense> objectList = [];
    int totalPrice = 0;
    try {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('expense')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: true)
              .where('credit', isEqualTo: true)
              .get();
      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Expense yourObject = Expense.fromMap(doc.id, doc.data());
        objectList.add(yourObject);

        // Add the price to the total price
        totalPrice += yourObject.amount;
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.

    // Return both the objectList and the totalPrice
    return totalPrice.toString();
  }

  Future<String> fetchCurrentMonthBoughtSum(DateTime date) async {
    List<Expense> objectList = [];
    int totalPrice = 0;
    try {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('expense')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: false)
              .where('credit', isEqualTo: false)
              .get();
      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Expense yourObject = Expense.fromMap(doc.id, doc.data());
        objectList.add(yourObject);

        // Add the price to the total price
        totalPrice += yourObject.amount;
      }
    } catch (e) {
      debugPrint("Error fetching purchases: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.

    // Return both the objectList and the totalPrice
    return totalPrice.toString();
  }

  Future<List<Expense>> fetchCurrentMonthUserExpenseFromDB(
      String name, DateTime date) async {
    List<Expense> objectList = [];

    try {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('expense')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .where('name', isEqualTo: name)
              .orderBy('date', descending: true)
              .get();

      for (var doc in querySnapshot.docs) {
        Expense expense = Expense.fromMap(doc.id, doc.data());
        objectList.add(expense);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    notifyListeners();
    return objectList;
  }

//user expense given total
  Future<String> userExpenseGivenTotalAmount(String name, DateTime date) async {
    List<Expense> objectList = [];
    int totalPrice = 0;
    try {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('expense')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: false)
              .where('credit', isEqualTo: true)
              .where('name', isEqualTo: name)
              .get();
      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Expense yourObject = Expense.fromMap(doc.id, doc.data());
        objectList.add(yourObject);

        // Add the price to the total price
        totalPrice += yourObject.amount;
      }
    } catch (e) {
      debugPrint("Error fetching expense list: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.

    // Return both the objectList and the totalPrice
    return totalPrice.toString();
  }

//user expense bought total
  Future<String> userExpenseBoughtTotalAmount(
      String name, DateTime date) async {
    List<Expense> objectList = [];
    int totalPrice = 0;
    try {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      // Get the last day of the month
      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('expense')
              .where('date',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
              .where('date',
                  isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
              .orderBy('date', descending: false)
              .where('credit', isEqualTo: false)
              .where('name', isEqualTo: name)
              .get();
      // Iterate through the documents and convert them into a list of Transactions objects
      for (var doc in querySnapshot.docs) {
        Expense yourObject = Expense.fromMap(doc.id, doc.data());
        objectList.add(yourObject);

        // Add the price to the total price
        totalPrice += yourObject.amount;
      }
    } catch (e) {
      debugPrint("Error fetching expense list: $e");
    }

    notifyListeners(); // Notify listeners if you're using a state management solution like ChangeNotifier.

    // Return both the objectList and the totalPrice
    return totalPrice.toString();
  }
}
