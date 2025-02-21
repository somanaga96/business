import 'package:flutter/material.dart';

class PeriodInput extends StatelessWidget {
  final String tenureType;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;

  const PeriodInput({
    Key? key,
    required this.tenureType,
    required this.switchValue,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tenureType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({Key? key}) : super(key: key);

  @override
  _SwitchExampleState createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  final List<String> _tenureTypes = ["வரவு", "செலவு"];
  String _tenureType = "வரவு";
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PeriodInput(
          tenureType: _tenureType,
          switchValue: _switchValue,
          onSwitchChanged: (value) {
            setState(() {
              _tenureType = value ? _tenureTypes[1] : _tenureTypes[0];
              _switchValue = value;
            });
          },
        ),
      ),
    );
  }
}
