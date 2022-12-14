import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double daySpending;
  final String label;
  final double daySPercentage;

  const ChartBar(this.label, this.daySpending, this.daySPercentage,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(children: [
        SizedBox(
          height: constraints.maxHeight * 0.15,
          child: FittedBox(
            child: Text(
              "₺${daySpending.toStringAsFixed(0)}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.05),
        SizedBox(
          height: constraints.maxHeight * 0.6,
          width: 10,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                color: const Color.fromRGBO(220, 220, 220, 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              heightFactor: daySPercentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ]),
        ),
        SizedBox(height: constraints.maxHeight * 0.05),
        SizedBox(
          height: constraints.maxHeight * 0.15,
          child: FittedBox(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ]);
    });
  }
}
