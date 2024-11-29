import 'package:business/component/entity/expense.dart';
import 'package:business/component/utils/expense_crud/expense_tool.dart';
import 'package:flutter/cupertino.dart';

import '../entity/user.dart';
import '../entity/transaction.dart';
import 'business_crud/transactions_tool.dart';
import 'business_crud/user_tool.dart';

class Global extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    getCreditTransactions();
    getDebitTransactions();
    getCurrentMonthExpenseTransaction();
    getCurrentMonthExpenseGivenTotal();
    getCurrentMonthExpenseBoughtTotal();
  }

  DateTime get selectedDate => _selectedDate;

  //username and password
  List<User> userList = [];

  void getUserListForLogin() async {
    userList.clear();
    try {
      UserTool tools = UserTool();
      List<User> transactions = await tools.fetchAllUsersFromDB();
      userList.addAll(transactions);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  //purchase details
  List<Transactions> purchaseList = [];

  void getTransactionsDetails() async {
    purchaseList.clear();
    try {
      TransactionsTool transactionsTool = TransactionsTool();
      // List<Transactions> purchases =
      //     await transactionsTool.fetchAllPurchaseFromDB();
      List<Transactions> purchases =
          await transactionsTool.fetchCurrentMonthPurchaseFromDB(_selectedDate);
      purchaseList.addAll(purchases);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  String _purchaseCreditList = "";

  String get purchaseCreditList => _purchaseCreditList;

  set purchaseCreditList(String value) {
    _purchaseCreditList = value;
  }

  void getCreditTransactions() async {
    try {
      TransactionsTool transactionsTool = TransactionsTool();
      purchaseCreditList =
          await transactionsTool.fetchAllMonthCreditFromDB(_selectedDate);

      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  String _purchaseDebitList = "";

  String get purchaseDebiList => _purchaseDebitList;

  set purchaseDebiList(String value) {
    _purchaseDebitList = value;
  }

  void getDebitTransactions() async {
    try {
      TransactionsTool transactionsTool = TransactionsTool();
      _purchaseDebitList =
          await transactionsTool.fetchAllMonthDebitFromDB(_selectedDate);

      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  //purchase details
  List<Expense> expenseList = [];

  void getCurrentMonthExpenseTransaction() async {
    expenseList.clear();
    try {
      ExpenseTool expenseTool = ExpenseTool();
      List<Expense> expenses =
          await expenseTool.fetchCurrentMonthExpenseFromDB(_selectedDate);
      expenseList.addAll(expenses);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  String _expenseGivenTotal = "";

  String get expenseGivenTotal => _expenseGivenTotal;

  set expenseTotal(String value) {
    _expenseGivenTotal = value;
  }

  void getCurrentMonthExpenseGivenTotal() async {
    try {
      ExpenseTool expenseTool = ExpenseTool();
      _expenseGivenTotal =
          await expenseTool.fetchCurrentMonthGivenSum(_selectedDate);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  String _expenseBoughtTotal = "";

  String get expenseBoughtTotal => _expenseBoughtTotal;

  set expenseBoughtTotal(String value) {
    _expenseBoughtTotal = value;
  }

  void getCurrentMonthExpenseBoughtTotal() async {
    try {
      ExpenseTool expenseTool = ExpenseTool();
      _expenseBoughtTotal =
          await expenseTool.fetchCurrentMonthBoughtSum(_selectedDate);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }
}
