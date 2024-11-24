import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/business_crud/transactions_tool.dart';
import '../../utils/global.dart';

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
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent independent scrolling
                  shrinkWrap: true,
                  // Let ListView adapt to available space
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
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
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
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool? confirmDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are you sure you want to delete this transaction?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(false); // User canceled
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(true); // User confirmed
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // If the user confirms deletion, proceed to delete
                                  if (confirmDelete == true) {
                                    await transactionsTool.deleteTransaction(
                                        context, transaction.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
