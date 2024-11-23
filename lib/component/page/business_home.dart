import 'package:business/component/utils/firebase_crud/transactions_tool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cards/purchase_expense_card.dart';
import '../utils/firebase_crud/month_selection_page.dart';
import '../utils/global.dart';
import 'business_transactions.dart';
import 'home.dart';

class BusinessHome extends StatefulWidget {
  const BusinessHome({super.key});

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  TransactionsTool transactionsTool = TransactionsTool();

  @override
  void initState() {
    super.initState();
    Provider.of<Global>(context, listen: false).getTransactionsDetails();
    Provider.of<Global>(context, listen: false).getCreditTransactions();
    Provider.of<Global>(context, listen: false).getDebitTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(child: Text('Business Home')),
            ElevatedButton(
              onPressed: () {
                // Logout logic and navigation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ), // Replace with your login page
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue,
      ),
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
