import 'package:business/component/page/user/users_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bottom_navigation.dart';
import '../page/home.dart';
import '../page/products/product_page.dart';
import 'global.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global>(
        builder: (context, global, child) => Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(child: Text(global.getAppTitle())),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
                backgroundColor: Colors.lightBlue,
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => userList()),
                        );
                      },
                      icon: Icon(
                        Icons.supervised_user_circle_sharp,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()),
                        );
                      },
                      icon: Icon(
                        Icons.production_quantity_limits_sharp,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        global.toggleTheme();
                      },
                      icon: Icon(global.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.wb_sunny),
                    ),
                  ],
                ),
              ),
              body: const BottomNavigation(),
            ));
  }
}
