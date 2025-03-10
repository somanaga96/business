import 'package:flutter/material.dart';

class FormattedValueText extends StatelessWidget {
  final double rate;
  final int quantity;

  const FormattedValueText({
    super.key,
    required this.rate,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    double total = rate * quantity;
    String displayValue =
    (total % 1 == 0) ? '${total.toInt()}' : total.toStringAsFixed(2);

    return Text(
      '$quantity = $displayValue',
      style: TextStyle(fontSize: 50),
    );
  }
}
