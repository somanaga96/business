import 'package:business/component/entity/expense.dart';
import 'package:business/component/entity/purchase.dart';
import 'package:business/component/page/user/user_crud.dart';
import 'package:business/component/utils/purchase_crud/purchase_tool.dart';
import 'package:flutter/cupertino.dart';
import '../entity/user.dart';
import '../entity/transaction.dart';
import '../entity/users.dart';
import '../page/products/product_crud.dart';
import 'business_crud/business_transactions_tool.dart';
import 'cumulative_crud/cumulative_crud.dart';
import 'user_crud/user_tool.dart';
import 'expense_crud/expense_tool.dart';

class Global extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String _businessName = "வியாபாரம்";
  String _name = "";
  String _appTitle = "Business Home";

  void setAppTitle(String name) {
    _appTitle = name;
  }

  String getAppTitle() => _appTitle;

  void setBusinessName(String name) {
    _businessName = name;
  }

  String getBusinessName() => _businessName;

  void setName(String name) {
    _businessName = name;
  }

  String getName() => _name;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    getCreditTransactions();
    getDebitTransactions();
    getCurrentMonthExpenseTransaction();
    getCurrentMonthExpenseGivenTotal();
    getCurrentMonthExpenseBoughtTotal();
    getUserTransactionTotal(_businessName);
    getUserTotalExpenseList(_name);
    getUserTotalExpenseList(_name);

    // getUserExpenseGivenTotal(_name);
    // getUserExpenseBoughtTotal(_name);
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

  void getUserTotalExpenseList(String name) async {
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

  // //userGivenExpenseTotal
  String _userExpenseGivenTotal = "";

  String get userExpenseGivenTotal => _userExpenseGivenTotal;

  set userExpenseGivenTotal(String value) {
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

  // //userBoughtExpenseTotal
  String _userExpenseBoughtTotal = "";

  String get userExpenseBoughtTotal => _userExpenseBoughtTotal;

  set userExpenseBoughtTotal(String value) {
    _userExpenseBoughtTotal = value;
  }

  void getUserExpenseBoughtTotal(String name) async {
    try {
      ExpenseTransactionsTool transactionsTool = ExpenseTransactionsTool();
      _userExpenseBoughtTotal = await transactionsTool
          .userExpenseBoughtTotalAmount(name, _selectedDate);
      notifyListeners();
    } catch (error) {
      print('Error fetching getUserTransactionTotal: $error');
    }
  }

  //products details
  List<Products> productsList = [];

  void getProductsList() async {
    productsList.clear();
    try {
      ProductTool productTool = ProductTool();
      List<Products> products = await productTool.fetchProductProductsFromDB();
      productsList.addAll(products);
      notifyListeners();
    } catch (error) {
      print('Error fetching getProductsList: $error');
    }
  }

  //list of Users
  List<Users> _customerList = [];

  void fetchCustomerList() async {
    _customerList.clear(); // Clear the list to avoid duplicates
    try {
      UserCrud tool = UserCrud(); // Assuming this fetches user data
      List<Users> liveTransactions = await tool.fetchUserList();
      _customerList
          .addAll(liveTransactions); // Add the fetched users to the list
      print(
          'Customer list: $_customerList'); // Print the customer list in console
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (error) {
      print('Error fetching users: $error'); // Handle errors gracefully
    }
  }

  // Getter to access the products list
  List<Users> get customerList => _customerList;

  //list of Users
  List<Products> _productList = [];

  void fetchProductList() async {
    _productList.clear(); // Clear the list to avoid duplicates
    try {
      ProductCrud tool = ProductCrud(); // Assuming this fetches user data
      List<Products> liveTransactions = await tool.fetchProductList();
      _productList
          .addAll(liveTransactions); // Add the fetched users to the list
      print(
          'Customer list: $_customerList'); // Print the customer list in console
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (error) {
      print('Error fetching users: $error'); // Handle errors gracefully
    }
  }

  List<Products> get productList => _productList;

// List to store cumulative expenses for each user
  List<Map<String, dynamic>> cumulativeExpenses = [];

  // Getter to access the cumulative expenses data
  List<Map<String, dynamic>> get getCumulativeExpenses => cumulativeExpenses;

  // Fetch cumulative user expenses asynchronously
  Future<void> fetchCumulativeUserExpense() async {
    // cumulativeExpenses.clear();
    try {
      CustomerExpenseService customerExpenseService = CustomerExpenseService();

      // Await the result from fetchCumulativeUserExpenses and assign it to the cumulativeExpenses
      cumulativeExpenses =
          await customerExpenseService.fetchCumulativeUserExpenses();

      // Optionally log the cumulative expenses
      print('Fetched cumulative expenses: $cumulativeExpenses');
    } catch (e) {
      print('Error fetching cumulative expenses: $e');
    }
  }
}
