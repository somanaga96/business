import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/global.dart';

class ExpenseIncomeCard extends StatelessWidget {
  const ExpenseIncomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<Global>(
      builder: (context, global, child) {
        return Row(
          children: [
            // Income Card
            Card(
              color: Colors.green[300],
              child: SizedBox(
                width: screenSize.width / 2.1,
                height: screenSize.height / 6,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "கொடுத்தது", // "Income" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        global.expenseGivenTotal,
                        // "Income" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expense Card
            Card(
              color: Colors.red[500],
              child: SizedBox(
                width: screenSize.width / 2.1,
                height: screenSize.height / 6,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "வாங்கியது", // "Expense" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        global.expenseBoughtTotal, // "Expense" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
