import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/firebase_crud/transactions_tool.dart';
import '../utils/global.dart';

class BusinessTransactions extends StatefulWidget {
  const BusinessTransactions({super.key});

  @override
  State<BusinessTransactions> createState() => _BusinessTransactionsState();
}

class _BusinessTransactionsState extends State<BusinessTransactions> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TransactionsTool transactionsTool = TransactionsTool();

    return Consumer<Global>(
      builder: (context, global, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (global.purchaseList.isEmpty) {
          return const Center(
              child: Text('No live transactions are available.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: global.purchaseList.length,
          itemBuilder: (BuildContext context, int index) {
            final DateFormat formatter = DateFormat('d-MMM-yy');
            String dateAndMonth =
                formatter.format(global.purchaseList[index].date);
            final transaction = global.purchaseList[index];

            return Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Space between content and icons
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${transaction.name} : ${transaction.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: transaction.credit
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          Text(
                            dateAndMonth,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Edit and Delete Icons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          transactionsTool.updateTransaction(
                            context,
                            transaction.id,
                            {
                              'name': transaction.name,
                              'price': transaction.price,
                              'credit': transaction.credit,
                              'date': transaction.date,
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await transactionsTool.deleteTransaction(
                              context, transaction.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
