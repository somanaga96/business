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
    final TransactionsTool transactionsTool = TransactionsTool();

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
          child: ListView.builder(
            itemCount: global.purchaseList.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = global.purchaseList[index];
              final DateFormat formatter = DateFormat('d-MMM-yy');
              final String dateAndMonth = formatter.format(transaction.date);

              return TransactionItem(
                transaction: transaction,
                dateAndMonth: dateAndMonth,
                transactionsTool: transactionsTool,
              );
            },
          ),
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final transaction;
  final String dateAndMonth;
  final TransactionsTool transactionsTool;

  const TransactionItem({
    required this.transaction,
    required this.dateAndMonth,
    required this.transactionsTool,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Container height is based on screen height to make it responsive
    double containerHeight = screenHeight / 18;

    // Horizontal and vertical padding, based on screen width and height
    double horizontalPadding = screenWidth * 0.03;
    double verticalPadding = screenHeight * 0.01;

    // Adjusted positioning ratios for centering and spacing
    double leftPosition = screenWidth * 0.05;
    double topPosition = containerHeight * 0.2;
    double priceLeftPosition = (screenWidth / 2) - 50;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: double.infinity,
        height: containerHeight,
        child: Stack(
          children: [
            Positioned(
              left: leftPosition,
              top: topPosition,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.credit ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    dateAndMonth,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Positioned(
              top: containerHeight / 2 - 15, // Adjusted vertically center
              left: priceLeftPosition, // Horizontally centered
              child: SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    '${transaction.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.credit ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: horizontalPadding,
              top: verticalPadding,
              bottom: verticalPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
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

                      if (confirmDelete == true) {
                        await transactionsTool.deleteTransaction(
                            context, transaction.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
