// import 'package:business/component/cards/ExpenseIncomeCard.dart';
// import 'package:business/component/utils/expense_crud/expense_tool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cards/expense_income_card.dart';
import '../../utils/business_crud/month_selection_page.dart';
import '../../utils/expense_crud/expense_tool.dart';
import '../../utils/global.dart';
import 'expense_transactions.dart';
// import 'expense_transaction.dart';

class ExpenseHome extends StatefulWidget {
  const ExpenseHome({super.key});

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  ExpenseTransactionsTool expenseTool = ExpenseTransactionsTool();

  @override
  void initState() {
    super.initState();
    Provider.of<Global>(context, listen: false)
        .getCurrentMonthExpenseTransaction();
    Provider.of<Global>(context, listen: false)
        .getCurrentMonthExpenseGivenTotal();
    Provider.of<Global>(context, listen: false)
        .getCurrentMonthExpenseBoughtTotal();
    Provider.of<Global>(context, listen: false).setAppTitle("Expense Home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          ExpenseIncomeCard(),
          MonthSelectionPage(),
          ExpenseTransactions(),
          // BusinessTransactions()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            expenseTool.createExpenseTransaction(context), // Correct invocation
      ),
    );
  }
}
