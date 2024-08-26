import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';
import 'package:survey_monkey/screens/graphs/barChart.dart';
import 'package:survey_monkey/screens/graphs/history.dart';
import 'package:survey_monkey/screens/graphs/pieChart.dart';
import 'package:survey_monkey/screens/surveyQuestions.dart';
import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

enum ChartType { bar, pie }

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late Future _future;
  String selectedGender = 'All';
  String selectedDiscipline = 'All';

  @override
  void initState() {
    super.initState();
    _future =
        Db().results(gender: selectedGender, discipline: selectedDiscipline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Results", style: TextStyle(fontSize: 20, color: ck.x)),
            gap20(),
            _buildFilters(),
            gap20(),
            Expanded(child: _futureBuild()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _showChart(ChartType.bar),
                  child: Text('Show Bar Chart'),
                ),
                ElevatedButton(
                  onPressed: () => _showChart(ChartType.pie),
                  child: Text('Show Pie Chart'),
                ),
              ],
            ),
            gap20(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: selectedGender,
          items: <String>['All', 'Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedGender = newValue!;
              _applyFilters();
            });
          },
        ),
        const SizedBox(width: 20),
        DropdownButton<String>(
          value: selectedDiscipline,
          items: <String>['All', 'BS IT', 'CS', 'SE', 'AI'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedDiscipline = newValue!;
              _applyFilters();
            });
          },
        ),
      ],
    );
  }

  void _applyFilters() {
    setState(() {
      _future =
          Db().results(gender: selectedGender, discipline: selectedDiscipline);
    });
  }

  Widget _futureBuild() {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _list(snapshot);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _list(AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, i) {
        Map data = snapshot.data[i];
        return GestureDetector(
          onTap: () {
            Get.to(SurveyQuestion.set(
              id: data['id'],
              surveyId: data['responses'][0]['surveyid'].toString(),
            ));
          },
          child: Container(
            color: Colors.red,
            width: Get.width,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data['name']),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showChart(ChartType.bar),
                      color: ck.x,
                      icon: const Icon(Icons.bar_chart),
                    ),
                    IconButton(
                      onPressed: () => _showChart(ChartType.pie),
                      color: ck.x,
                      icon: const Icon(Icons.pie_chart),
                    ),
                    IconButton(
                      onPressed: () {
                        User.tempSurveyId = data['id'];
                        Get.to(() => const History());
                      },
                      color: ck.x,
                      icon: const Icon(Icons.history),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChart(ChartType type) {
    List<double> chartData =
        ChartData.getChartData(selectedGender, selectedDiscipline);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget chartWidget = type == ChartType.bar
            ? BarChartWidget(yValues: chartData)
            : PieChartWidget(values: chartData);

        return Dialog(
          child: Container(
            height: 400, // Adjust based on your UI needs
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: chartWidget,
          ),
        );
      },
    );
  }
}

class ChartData {
  static Map<String, Map<String, List<double>>> data = {
    'All': {
      'All': [10, 30, 20, 25],
      'BS IT': [15, 25, 35, 20],
      'CS': [20, 20, 40, 10],
      'SE': [25, 15, 30, 20],
      'AI': [30, 20, 25, 15],
    },
    'Male': {
      'All': [12, 28, 25, 20],
      'BS IT': [10, 20, 30, 25],
      'CS': [20, 15, 35, 20],
      'SE': [25, 25, 20, 20],
      'AI': [15, 30, 25, 20],
    },
    'Female': {
      'All': [10, 25, 30, 20],
      'BS IT': [20, 20, 30, 20],
      'CS': [15, 35, 25, 15],
      'SE': [30, 20, 15, 25],
      'AI': [20, 25, 20, 25],
    },
  };

  static List<double> getChartData(String gender, String discipline) {
    return data[gender]?[discipline] ?? [0, 0, 0, 0];
  }
}
