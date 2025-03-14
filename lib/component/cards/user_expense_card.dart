import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/global.dart';

class UserExpenseCard extends StatelessWidget {
  final String title;

  const UserExpenseCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<Global>(
      builder: (context, global, child) {
        return Row(
          children: [
            Card(
              color: Colors.red[500],
              child: SizedBox(
                width: screenSize.width / 2.1,
                height: screenSize.height / 6,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'வாங்கியது', // "Income" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        global.userExpenseBoughtTotal, // "Expense" in Tamil
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
              color: Colors.green[300],
              child: SizedBox(
                width: screenSize.width / 2.1,
                height: screenSize.height / 6,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "கொடுத்தது", // "Expense" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        global.userExpenseGivenTotal, // "Expense" in Tamil
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
