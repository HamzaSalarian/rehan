// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Helper/User.dart';
import '../../http/db.dart';

class PieChartT extends StatefulWidget {
  const PieChartT({super.key});

  @override
  State<PieChartT> createState() => _PieChartTState();
}

class _PieChartTState extends State<PieChartT> {
  late Future future;

  @override
  Widget build(BuildContext context) {
    future = Db().calculateTeacherGraph(sid: User.tempSurveyId);
    return Scaffold(
      body: Center(
        child: _futureBuild(),
      ),
    );
  }

  Widget _futureBuild() {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _list(snapshot);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _list(AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        Map data = snapshot.data[index];
        return SfCircularChart(
          legend: const Legend(isVisible: true),
          title: ChartTitle(
            text: data['question'],
          ),
          series: <PieSeries<SalesData, String>>[
            _createPieSeries(
              "Excellent",
              data['excelent'],
              "Good",
              data['good'],
              "Bad",
              data['bad'],
              "Worse",
              data['worse'],
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
  ) {
    return PieSeries<SalesData, String>(
      dataSource: <SalesData>[
        SalesData(op1, v1),
        SalesData(op2, v2),
        SalesData(op3, v3),
        SalesData(op4, v4),
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
