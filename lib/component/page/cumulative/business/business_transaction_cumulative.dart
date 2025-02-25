import 'package:flutter/material.dart';

import '../expense/user_expense_cumulative_page.dart';

class ExpenseCumulative extends StatefulWidget {
  const ExpenseCumulative({super.key});

  @override
  State<ExpenseCumulative> createState() => _ExpenseCumulativeState();
}

class _ExpenseCumulativeState extends State<ExpenseCumulative> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("மொத்த செலவு"),
        backgroundColor: Colors.lightBlue,
      ),
      body: UserExpenseCumulativePage(),
    );
  }
}
