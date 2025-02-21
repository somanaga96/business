import 'package:business/component/entity/expense.dart';
import 'package:business/component/entity/purchase.dart';
import 'package:business/component/utils/purchase_crud/purchase_tool.dart';

// import 'package:business/component/utils/expense_crud/expense_tool.dart';
import 'package:flutter/cupertino.dart';

import '../entity/user.dart';
import '../entity/transaction.dart';
import 'business_crud/business_transactions_tool.dart';
import 'user_crud/user_tool.dart';
import 'expense_crud/expense_tool.dart';

class Global extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String _name = "வியாபாரம்";

  void setName(String name) {
    _name = name;
  }

  String getName() => _name;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    getCreditTransactions();
    getDebitTransactions();
    // getCurrentMonthExpenseTransaction();
    // getCurrentMonthExpenseGivenTotal();
    // getCurrentMonthExpenseBoughtTotal();
    getUserTransactionTotal(_name);
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
      print('Error fetching getUserListForLogin: $error');
    }
  }

  //purchase details
  List<Transactions> purchaseList = [];

  void getTransactionsDetails() async {
    purchaseList.clear();
    try {
      BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();
      // List<Transactions> purchases =
      //     await transactionsTool.fetchAllPurchaseFromDB();
      List<Transactions> purchases =
          await transactionsTool.fetchCurrentMonthPurchaseFromDB(_selectedDate);
      purchaseList.addAll(purchases);
      notifyListeners();
    } catch (error) {
      print('Error fetching getTransactionsDetails: $error');
    }
  }

  String _purchaseCreditList = "";

  String get purchaseCreditList => _purchaseCreditList;

  set purchaseCreditList(String value) {
    _purchaseCreditList = value;
  }

  void getCreditTransactions() async {
    try {
      BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();
      purchaseCreditList =
          await transactionsTool.fetchAllMonthCreditFromDB(_selectedDate);

      notifyListeners();
    } catch (error) {
      print('Error fetching getCreditTransactions: $error');
    }
  }

  String _purchaseDebitList = "";

  String get purchaseDebiList => _purchaseDebitList;

  set purchaseDebiList(String value) {
    _purchaseDebitList = value;
  }

  void getDebitTransactions() async {
    try {
      BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();
      _purchaseDebitList =
          await transactionsTool.fetchAllMonthDebitFromDB(_selectedDate);

      notifyListeners();
    } catch (error) {
      print('Error fetching getDebitTransactions: $error');
    }
  }

  //purchase details
  List<Expense> expenseList = [];

  void getCurrentMonthExpenseTransaction() async {
    expenseList.clear();
    try {
      ExpenseTransactionsTool expenseTool = ExpenseTransactionsTool();
      List<Expense> expenses =
          await expenseTool.fetchCurrentMonthExpenseFromDB(_selectedDate);
      for (var expense in expenses) {
        print('Expense Name: ${expense.name.toString()}');
        print('Expense date: ${expense.date.toString()}');
        print('Expense credit: ${expense.credit.toString()}');
        print('Expense amount: ${expense.amount.toString()}');
      }
      expenseList.addAll(expenses);
      notifyListeners();
    } catch (error) {
      print('Error fetching getCurrentMonthExpenseTransaction: $error');
    }
  }

  String _expenseGivenTotal = "";

  String get expenseGivenTotal => _expenseGivenTotal;

  set expenseTotal(String value) {
    _expenseGivenTotal = value;
  }

  void getCurrentMonthExpenseGivenTotal() async {
    try {
      ExpenseTransactionsTool expenseTool = ExpenseTransactionsTool();
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
      ExpenseTransactionsTool expenseTool = ExpenseTransactionsTool();
      _expenseBoughtTotal =
          await expenseTool.fetchCurrentMonthBoughtSum(_selectedDate);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  //userTotalTransactionList details
  List<Transactions> totalTransactionList = [];

  void getUserTotalTransactionsDetails(String name) async {
    totalTransactionList.clear();
    try {
      BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();
      List<Transactions> purchases = await transactionsTool
          .fetchCurrentMonthUserPurchaseFromDB(name, _selectedDate);
      totalTransactionList.addAll(purchases);
      notifyListeners();
    } catch (error) {
      print('Error fetching getUserTotalTransactionsDetails: $error');
    }
  }

  //userTotal
  String _purchaseProductTotal = "";

  String get purchaseProductTotal => _purchaseProductTotal;

  set purchaseProductTotal(String value) {
    _purchaseProductTotal = value;
  }

  void getUserTransactionTotal(String name) async {
    try {
      BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();
      _purchaseProductTotal =
          await transactionsTool.purchaseProductTotal(name, _selectedDate);
      notifyListeners();
    } catch (error) {
      print('Error fetching getUserTransactionTotal: $error');
    }
  }

  //userTotalExpenseList details
  List<Expense> userTotalExpenseList = [];

  void getUserTotalExpenseDetails(String name) async {
    userTotalExpenseList.clear();
    try {
      ExpenseTransactionsTool expenseTool = ExpenseTransactionsTool();
      List<Expense> expenses = await expenseTool
          .fetchCurrentMonthUserExpenseFromDB(name, _selectedDate);
      userTotalExpenseList.addAll(expenses);
      notifyListeners();
    } catch (error) {
      print('Error fetching getUserTotalTransactionsDetails: $error');
    }
  }

  // //userExpenseTotal
  String _userExpenseGivenTotal = "";

  String get userExpenseGivenTotal => _userExpenseGivenTotal;

  set userExpenseCreditTotal(String value) {
    _userExpenseGivenTotal = value;
  }

  void getUserExpenseGivenTotal(String name) async {
    try {
      ExpenseTransactionsTool transactionsTool = ExpenseTransactionsTool();
      _userExpenseGivenTotal = await transactionsTool
          .userExpenseGivenTotalAmount(name, _selectedDate);
      notifyListeners();
    } catch (error) {
      print('Error fetching getUserTransactionTotal: $error');
    }
  }

  //products details
  List<Product> productsList = [];

  void getProductsList() async {
    productsList.clear();
    try {
      ProductTool productTool = ProductTool();
      List<Product> products = await productTool.fetchProductProductsFromDB();
      productsList.addAll(products);
      notifyListeners();
    } catch (error) {
      print('Error fetching getProductsList: $error');
    }
  }
}
