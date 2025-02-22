import 'package:flutter/material.dart';

class Egg extends StatefulWidget {
  const Egg({super.key});

  @override
  State<Egg> createState() => _EggState();
}

class _EggState extends State<Egg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Set"),
    );
  }
}
