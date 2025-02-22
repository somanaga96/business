import 'package:business/component/page/userExpense/user_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cards/user_expense_card.dart';
import '../../utils/business_crud/month_selection_page.dart';
import '../../utils/global.dart';

class UserIndividualPage extends StatefulWidget {
  final String name;

  const UserIndividualPage({super.key, required this.name});

  // getUserExpenseGivenTotal

  @override
  State<UserIndividualPage> createState() => _UserIndividualPageState();
}

class _UserIndividualPageState extends State<UserIndividualPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<Global>(context, listen: false)
        .getUserExpenseGivenTotal(widget.name);
    Provider.of<Global>(context, listen: false)
        .getUserExpenseBoughtTotal(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.name} Expense'),
        ),
        body: Column(children: [
          UserExpenseCard(
            title: widget.name,
          ),
          MonthSelectionPage(),
          UserTransactions(
            name: widget.name,
          )
        ]));
  }
}
