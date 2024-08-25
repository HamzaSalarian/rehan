import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Helper/Graph.dart';
import '../../http/db.dart';

// ignore: must_be_immutable
class PieChart extends StatefulWidget {
  final int id;
  final Map data;
  final bool status;
  PieChart(
      {super.key, required this.id, required this.data, required this.status});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  bool _dataLoaded = false;
  List<double> skippedCounts = []; // List to store skipped counts

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var q = await Db().calculateGraph(sid: widget.id);
    print('id--->${widget.id}');
    print('q $q');

    // Calculate skipped counts based on the data
    for (var response in widget.data['responses']) {
      double total = response['op1'] +
          response['op2'] +
          (response['op3'] ?? 0) +
          (response['op4'] ?? 0);
      double skipped =
          q - total; // Assuming 'q' is the total number of responses expected
      skippedCounts.add(skipped);
    }

    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _dataLoaded ? _list() : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _list() {
    var count = 0;
    if (widget.status) {
      count = 1;
    } else {
      count = widget.data['responses'] == null
          ? 0
          : widget.data['responses']!.length;
    }

    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, i) {
        return SfCircularChart(
          legend: const Legend(isVisible: true),
          title: ChartTitle(
            text: widget.data['responses'][i]['title'],
          ),
          series: <PieSeries<SalesData, String>>[
            _createPieSeries(
              widget.data['responses'][i]['op1'],
              Graph.v1,
              widget.data['responses'][i]['op2'],
              Graph.v2,
              widget.data['responses'][i]['op3'] ?? '',
              Graph.v3,
              widget.data['responses'][i]['op4'] ?? '',
              Graph.v4,
              'Skipped',
              skippedCounts[i], // Pass the calculated skipped count
            ),
          ],
        );
      },
    );
  }

  PieSeries<SalesData, String> _createPieSeries(
    String op1,
    double v1,
    String op2,
    double v2,
    String op3,
    double v3,
    String op4,
    double v4,
    String skipped, // Added for skipped questions
    double vSkipped, // Added value for skipped questions
  ) {
    return PieSeries<SalesData, String>(
      dataSource: <SalesData>[
        SalesData(op1, v1),
        SalesData(op2, v2),
        SalesData(op3, v3),
        SalesData(op4, v4),
        SalesData(
            skipped, vSkipped), // Include skipped responses in the data source
      ],
      xValueMapper: (SalesData sales, _) => sales.question,
      yValueMapper: (SalesData sales, _) => sales.ans,
    );
  }
}

class SalesData {
  SalesData(this.question, this.ans);
  final String question;
  final double ans;
}
