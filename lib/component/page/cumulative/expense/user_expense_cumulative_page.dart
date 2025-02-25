import 'package:business/component/page/user/user_crud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/global.dart';

class UserExpenseCumulativePage extends StatefulWidget {
  const UserExpenseCumulativePage({super.key});

  @override
  State<UserExpenseCumulativePage> createState() => _OpenLoansState();
}

class _OpenLoansState extends State<UserExpenseCumulativePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    Provider.of<Global>(context, listen: false).fetchCustomerList();
    Provider.of<Global>(context, listen: false).fetchCumulativeUserExpense();
  }

  void fetchData() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserCrud userCrud = UserCrud();

    return Consumer<Global>(
        builder: (context, global, child) => Scaffold(
              body: Consumer<Global>(
                builder: (context, global, child) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (global.cumulativeExpenses.isEmpty) {
                    return const Center(
                        child: Text('No live loans are available.'));
                  }

                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: global.cumulativeExpenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: ListTile(
                            title: Text(
                              '${global.cumulativeExpenses[index]['name']} ${global.cumulativeExpenses[index]['totalExpense'].toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ));
  }
}
