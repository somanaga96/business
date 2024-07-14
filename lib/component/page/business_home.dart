import 'package:flutter/material.dart';

class BusinessHome extends StatefulWidget {
  const BusinessHome({super.key});

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: const Center(child: Text("Business Home")));
  }
}
