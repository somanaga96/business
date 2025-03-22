import 'package:business/component/egg/egg_screen.dart';
import 'package:business/component/page/business/business_home.dart';
import 'package:business/component/page/expense/expense_home.dart';
import 'package:business/component/page/settings/Settings.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  late List<Widget> screen;

  @override
  void initState() {
    super.initState();
    screen = [BusinessHome(), ExpenseHome(), EggScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedFontSize: 18,
        iconSize: 25,
        unselectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'வியாபாரம்',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'செலவு',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.egg),
            label: 'முட்டை',
          ),
        ],
      ),
    );
  }
}
