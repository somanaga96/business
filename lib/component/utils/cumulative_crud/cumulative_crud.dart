import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../entity/expense.dart';
import '../../entity/users.dart';
import '../../page/user/user_crud.dart';

class CustomerExpenseService extends ChangeNotifier {
  // Fetch the list of users and their cumulative expenses
  Future<List<Map<String, dynamic>>> fetchCumulativeUserExpenses() async {
    List<Map<String, dynamic>> cumulativeExpenses =
        []; // Local list to store cumulative expenses

    try {
      // Step 1: Fetch all users from the Firestore 'users' collection
      UserCrud userCrud = UserCrud();
      List<Users> customers = await userCrud.fetchUserList();

      for (var customer in customers) {
        int totalExpense = 0;

        // Step 2: Fetch all expenses for the current user by userId from the 'expenses' collection
        QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
            await FirebaseFirestore.instance
                .collection('expenses') // Firestore collection for expenses
                .where('userId',
                    isEqualTo: customer.id) // Link expenses to userId
                .get();

        // Step 3: Sum the amounts of all expenses for this user
        for (var expenseDoc in expenseSnapshot.docs) {
          var expenseData = expenseDoc.data();
          Expense expense = Expense.fromMap(expenseDoc.id, expenseData);

          // Add the amount of this expense to the total expense for the user
          totalExpense +=
              expense.amount; // Adjust as necessary (e.g., for credit expenses)
        }

        // Step 4: Add the cumulative expense information for this user to the list
        cumulativeExpenses.add({
          'userId': customer.id,
          'name': customer.name,
          'totalExpense': totalExpense,
        });
      }

      // Log the cumulative expenses (Optional)
      print('Cumulative Expenses: $cumulativeExpenses');

      // Return the list of cumulative expenses
      return cumulativeExpenses;
    } catch (e) {
      print('Error fetching cumulative expenses: $e');
      // In case of error, return an empty list
      return [];
    }
  }
}
