import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cards/purchase_expense_card.dart';
import '../../utils/business_crud/month_selection_page.dart';
import '../../utils/business_crud/business_transactions_tool.dart';
import '../../utils/global.dart';
import '../home.dart';
import 'business_transactions.dart';

class BusinessHome extends StatefulWidget {
  const BusinessHome({super.key});

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();

  @override
  void initState() {
    super.initState();
    Provider.of<Global>(context, listen: false).getTransactionsDetails();
    Provider.of<Global>(context, listen: false).getCreditTransactions();
    Provider.of<Global>(context, listen: false).getDebitTransactions();
    Provider.of<Global>(context, listen: false).setAppTitle('Home Expense');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          PurchaseIncomeCard(),
          MonthSelectionPage(),
          BusinessTransactions()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            transactionsTool.createTransaction(context), // Correct invocation
      ), // Use the new custom Row widget
    );
  }
}
