import 'package:business/component/utils/expense_crud/expense_tool.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../utils/global.dart';

class UserTransactions extends StatefulWidget {
  final String name;

  const UserTransactions({super.key, required this.name});

  @override
  State<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  bool isLoading = true;
  Global global = Global();

  @override
  void initState() {
    super.initState();
    fetchUserExpenses();
    global.setName(widget.name);
  }

  Future<void> fetchUserExpenses() async {
    Provider.of<Global>(context, listen: false)
        .getUserTotalExpenseList(widget.name);
    setState(() {
      isLoading = false;
    });
    print('Data fetched!');
  }

  void refreshTransactions() {
    setState(() {
      isLoading = true;
    });
    print('Refreshing transactions...');
    fetchUserExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global>(
      builder: (context, global, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (global.userTotalExpenseList.isEmpty) {
          print('userTotalExpenseList is empty.');
          return const Center(
              child: Text('No live transactions are available.'));
        }

        print(
            'User Expense List Loaded: ${global.userTotalExpenseList.length} transactions.');

        return Expanded(
          child: ListView.builder(
            itemCount: global.userTotalExpenseList.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = global.userTotalExpenseList[index];
              final DateFormat formatter = DateFormat('d-MMM-yy');
              final String dateAndMonth = formatter.format(transaction.date);
              final bool credit = transaction.credit;
              final String amount = transaction.amount.toString();
              final String comments = transaction.comments;
              print('Building list item for transaction: ${transaction.name}');

              return TransactionItem(
                  amount: amount,
                  transaction: transaction,
                  dateAndMonth: dateAndMonth,
                  creditName: credit,
                  expenseTransactionsTool: ExpenseTransactionsTool(),
                  comments: comments);
            },
          ),
        );
      },
    );
  }
}

class TransactionItem extends StatefulWidget {
  final amount;
  final transaction;
  final String dateAndMonth;
  final ExpenseTransactionsTool expenseTransactionsTool;
  final bool creditName;
  final String comments;

  const TransactionItem(
      {super.key,
      required this.amount,
      required this.transaction,
      required this.dateAndMonth,
      required this.expenseTransactionsTool,
      required this.creditName,
      required this.comments});

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Slidable(
      key: Key(widget.transaction.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              if (!mounted) return;

              print(
                  'Update action triggered for expense ID: ${widget.transaction.id}');

              Map<String, dynamic> currentData = {
                'name': widget.transaction.name,
                'amount': widget.transaction.amount,
                'credit': widget.transaction.credit,
                'date': widget.transaction.date,
                'comments': widget.transaction.comments
              };

              await widget.expenseTransactionsTool.updateExpense(
                mounted,
                context,
                widget.transaction.id,
                currentData,
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) async {
              if (!mounted) return;

              print(
                  'Delete action triggered for transaction ID: ${widget.transaction.id}');

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
                if (!mounted) return;
                await widget.expenseTransactionsTool
                    .deleteExpense(context, widget.transaction.id);
                print('Deleted transaction: ${widget.transaction.name}');

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
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Row(
            children: [
              Text(
                '${widget.transaction.name}',
                style: TextStyle(
                  color: widget.creditName ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: screenSize.width / 6),
              Text(
                '${widget.transaction.comments}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          subtitle: Text(widget.dateAndMonth),
          trailing: Text(
            widget.amount.toString(),
            style: TextStyle(
                fontSize: 18.0,
                color: widget.creditName ? Colors.green : Colors.red),
          ),
        ),
      ),
    );
  }
}
