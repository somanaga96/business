import 'package:business/component/utils/user_tool.dart';
import 'package:flutter/cupertino.dart';

import '../entity/user.dart';

class Global extends ChangeNotifier {
  List<User> userList = [];

  void getUserListForLogin() async {
    userList.clear();
    try {
      UserTool tools = UserTool();
      List<User> transactions = await tools.fetchAllUsersFromDB();
      userList.addAll(transactions);
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }
}
