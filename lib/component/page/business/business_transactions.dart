import 'package:business/component/page/business/user_transanction_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/business_crud/business_transactions_tool.dart';
import '../../utils/global.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  void refreshTransactions() {
    setState(() {
      isLoading = true;
    });
    fetchData(); // Refresh the data
  }

  @override
  Widget build(BuildContext context) {
    final BusinessTransactionsTool transactionsTool = BusinessTransactionsTool();

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
              final bool credit = transaction.credit;

              return TransactionItem(
                transaction: transaction,
                dateAndMonth: dateAndMonth,
                transactionsTool: transactionsTool,
                creditName: credit, // Pass callback
              );
            },
          ),
        );
      },
    );
  }
}

class TransactionItem extends StatefulWidget {
  final transaction;
  final String dateAndMonth;
  final BusinessTransactionsTool transactionsTool;
  final bool creditName;

  const TransactionItem(
      {super.key,
      required this.transaction,
      required this.dateAndMonth,
      required this.transactionsTool,
      required this.creditName});

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(widget.transaction.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              if (!mounted) return; // Ensure widget is still mounted
              await widget.transactionsTool.updateTransaction(
                mounted,
                context,
                widget.transaction.id,
                {
                  'name': widget.transaction.name,
                  'price': widget.transaction.price,
                  'credit': widget.transaction.credit,
                  'date': widget.transaction.date,
                },
              ); // Refresh after update
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) async {
              if (!mounted) return; // Ensure widget is still mounted
              bool? confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this transaction?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                if (!mounted) return; // Ensure widget is still mounted
                await widget.transactionsTool
                    .deleteTransaction(mounted, context, widget.transaction.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('${widget.transaction.name} deleted.')),
                );
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(
              widget.transaction.name,
              style: TextStyle(
                  color: widget.creditName ? Colors.green : Colors.red),
            ),
            subtitle: Text(widget.dateAndMonth),
            trailing: Text(
              widget.transaction.price.toString(),
              style: TextStyle(
                  fontSize: 18.0,
                  color: widget.creditName ? Colors.green : Colors.red),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserTransactionPage(
                          name: widget.transaction.name,
                        )),
              );
            },
          ),
        ),
      ),
    );
  }
}
