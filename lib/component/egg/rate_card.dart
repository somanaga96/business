import 'package:flutter/material.dart';
import 'formatted_value_text.dart';

class RateCard extends StatelessWidget {
  final double rate;

  const RateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    String amount =
        (rate % 1 == 0) ? '${rate.toInt()}' : rate.toStringAsFixed(2);
    return SizedBox(
      width: double.infinity, // Ensures full width
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title Section
            ListTile(
              title: Center(
                child: Text(
                  amount,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
              tileColor:
                  Colors.blue.shade100, // Light blue background for title
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FormattedValueText(rate: rate, quantity: 1),
                  FormattedValueText(rate: rate, quantity: 30),
                  FormattedValueText(rate: rate, quantity: 60),
                  FormattedValueText(rate: rate, quantity: 90),
                  FormattedValueText(rate: rate, quantity: 100),
                  FormattedValueText(rate: rate, quantity: 120),
                  FormattedValueText(rate: rate, quantity: 150),
                  FormattedValueText(rate: rate, quantity: 180),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
