import 'package:flutter/material.dart';
import '../../Values/values.dart';

import 'bar_chart.dart';

class ProductivityChart extends StatelessWidget {
  const ProductivityChart(
      {Key? key, required this.percentages, required this.message})
      : super(key: key);
  final List<double> percentages;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        height: 220,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: AppColors.primaryBackgroundColor),
        child: BarChartSample1(
          percentages: percentages,
          message: message,
        ));
  }
}
