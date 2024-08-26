import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final List<double> yValues;

  BarChartWidget({required this.yValues});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = List.generate(
      yValues.length,
      (i) => BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: yValues[i], color: Colors.blue)],
        showingTooltipIndicators: [0],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Bar Chart')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 50,
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }
}
