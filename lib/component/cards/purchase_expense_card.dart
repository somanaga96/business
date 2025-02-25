import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../page/cumulative/business/business_transaction_cumulative.dart';
import '../utils/global.dart';

class PurchaseIncomeCard extends StatelessWidget {
  const PurchaseIncomeCard({super.key});

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
                        "வரவு", // "Income" in Tamil
                        style: TextStyle(
                          fontSize: (screenSize.width / 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        global.purchaseCreditList,
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
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExpenseCumulative()),
                );
              },
              child: Card(
                color: Colors.red[500],
                child: SizedBox(
                  width: screenSize.width / 2.1,
                  height: screenSize.height / 6,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "செலவு", // "Expense" in Tamil
                          style: TextStyle(
                            fontSize: (screenSize.width / 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          global.purchaseDebiList, // "Expense" in Tamil
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
            ),
          ],
        );
      },
    );
  }
}
