import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final List<double> values;

  PieChartWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = List.generate(
      values.length,
          (i) => PieChartSectionData(
        color: Colors.primaries[i % Colors.primaries.length],
        value: values[i],
        title: '${values[i]}%',
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 50,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Pie Chart')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PieChart(
          PieChartData(sections: sections),
        ),
      ),
    );
  }
}