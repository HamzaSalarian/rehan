import 'package:flutter/material.dart';
import 'package:survey_monkey/widgets/spacers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Helper/Graph.dart';
import '../../http/db.dart';

class BarChart extends StatefulWidget {
  final int id;
  final Map data;
  const BarChart({super.key, required this.id, required this.data});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  bool _dataLoaded = false;

  var showAll = List<bool>.generate(100, (int index) => false);

  var selectedOption1 = List<bool>.generate(100, (int index) => false);
  var selectedOption2 = List<bool>.generate(100, (int index) => false);
  var selectedOption3 = List<bool>.generate(100, (int index) => false);
  var selectedOption4 = List<bool>.generate(100, (int index) => false);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    print('id--${widget.id}');
    await Db().calculateGraph(sid: widget.id);
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      body: Center(
        child: _dataLoaded ? _list() : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.data['responses'] == null
          ? 0
          : widget.data['responses']!.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              title: ChartTitle(
                text: widget.data['responses'][i]['title'],
              ),
              series: [
                if (showAll[i])
                  _createColumnSeries(
                    widget.data['responses'][i]['op1'],
                    Graph.v1,
                    widget.data['responses'][i]['op2'],
                    Graph.v2,
                    widget.data['responses'][i]['op3'] ?? '',
                    Graph.v3,
                    widget.data['responses'][i]['op4'] ?? '',
                    Graph.v4,
                  ),
                if (selectedOption1[i])
                  _createColumnSeries(
                    widget.data['responses'][i]['op1'],
                    Graph.v1,
                    '',
                    0,
                    '',
                    0,
                    '',
                    0,
                  ),
                if (selectedOption2[i])
                  _createColumnSeries(
                    '',
                    0,
                    widget.data['responses'][i]['op2'],
                    Graph.v2,
                    '',
                    0,
                    '',
                    0,
                  ),
                if (selectedOption3[i])
                  _createColumnSeries(
                    '',
                    0,
                    '',
                    0,
                    widget.data['responses'][i]['op3'],
                    Graph.v3,
                    '',
                    0,
                  ),
                if (selectedOption4[i])
                  _createColumnSeries(
                    '',
                    0,
                    '',
                    0,
                    '',
                    0,
                    widget.data['responses'][i]['op4'] != null
                    ? widget.data['responses'][i]['op4']
                        : "",
                    Graph.v4,
                  ),
              ],
            ),
            gap10(),

            Text('Skipped Count: '),

            Column(
              children: [
                Checkbox(
                  value: showAll[i],
                  onChanged: (bool? value) {
                    setState(() {
                      showAll[i] = value!;
                    });
                  },
                ),

             //   const Text('All'),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: selectedOption1[i],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOption1[i] = value!;
                        });
                      },
                    ),
                    Text(widget.data['responses'][i]['op1']),
                    Checkbox(
                      value: selectedOption2[i],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOption2[i] = value!;
                        });
                      },
                    ),
                    Text(widget.data['responses'][i]['op2']),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.data['responses'][i]['op3'].toString() != 'null'
                        ? Row(
                            children: [
                              Checkbox(
                                value: selectedOption3[i],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedOption3[i] = value!;
                                  });
                                },
                              ),
                              Text(widget.data['responses'][i]['op3']),
                            ],
                          )
                        : Container(),
                    widget.data['responses'][i]['op4'].toString() != 'null'
                        ? Row(
                            children: [
                              Checkbox(
                                value: selectedOption4[i],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedOption4[i] = value!;
                                  });
                                },
                              ),
                              Text(widget.data['responses'][i]['op4']
                                  .toString()),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            gap20(),
          ],
        );
      },
    );
  }

  ColumnSeries<SalesData, String> _createColumnSeries(
    String op1,
    double v1,
    String op2,
    double v2,
    String op3,
    double v3,
    String op4,
    double v4,
  ) {
    final List<SalesData> seriesData = [
      if (op1.isNotEmpty) SalesData(op1, v1),
      if (op2.isNotEmpty) SalesData(op2, v2),
      if (op3.isNotEmpty) SalesData(op3, v3),
      if (op4.isNotEmpty) SalesData(op4, v4),
    ];
    return ColumnSeries<SalesData, String>(
      dataSource: seriesData,
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
