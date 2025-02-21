import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class MonthSelectionPage extends StatefulWidget {
  const MonthSelectionPage({
    super.key,
  });

  @override
  State<MonthSelectionPage> createState() => _MonthSelectionPageState();
}

class _MonthSelectionPageState extends State<MonthSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Global>(
      builder: (context, global, child) => ElevatedButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: global.selectedDate,
            firstDate: DateTime(2010),
            lastDate: DateTime.now(),
          );
          if (newDate != null) {
            // Update selected date in the Global class
            global.setSelectedDate(newDate);
            // Call methods to update transaction data
            global.getTransactionsDetails();
            Provider.of<Global>(context, listen: false)
                .getUserTotalTransactionsDetails(global.getName());
            Provider.of<Global>(context, listen: false)
                .getCurrentMonthExpenseTransaction();
          }
        },
        child: Text(DateFormat('MMMM/y').format(global.selectedDate)),
      ),
    );
  }
}
