import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  String selectedGender = 'All';
  String selectedDiscipline = 'All';
  bool showBarChart = false;

  // Static data
  final List<Map<String, dynamic>> allData = [
    {
      'question': "What's your favorite programming language?",
      'responses': [
        {'label': 'Python', 'value': 70},
        {'label': 'Java', 'value': 45},
        {'label': 'C++', 'value': 30},
        {'label': 'JavaScript', 'value': 55},
        {'label': 'Skipped', 'value': 10},
      ],
      'gender': 'Male',
      'discipline': 'CS',
    },
    {
      'question': "Which framework do you prefer for app development?",
      'responses': [
        {'label': 'Flutter', 'value': 80},
        {'label': 'React Native', 'value': 50},
        {'label': 'Xamarin', 'value': 20},
        {'label': 'Skipped', 'value': 15},
      ],
      'gender': 'Female',
      'discipline': 'CS',
    },
  ];

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      filteredData = allData.where((data) {
        bool matchesGender =
            selectedGender == 'All' || data['gender'] == selectedGender;
        bool matchesDiscipline = selectedDiscipline == 'All' ||
            data['discipline'] == selectedDiscipline;
        return matchesGender && matchesDiscipline;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(showBarChart ? Icons.pie_chart : Icons.bar_chart),
            onPressed: () {
              setState(() {
                showBarChart = !showBarChart;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return _buildQuestionCard(filteredData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue!;
              _applyFilters();
            });
          },
          items: <String>['All', 'Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: selectedDiscipline,
          onChanged: (String? newValue) {
            setState(() {
              selectedDiscipline = newValue!;
              _applyFilters();
            });
          },
          items: <String>['All', 'BS IT', 'CS', 'SE', 'AI']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> questionData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              questionData['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: showBarChart
                  ? BarChart(
                      BarChartData(
                        barGroups: _buildBarGroups(questionData['responses']),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: false),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: _buildPieSections(questionData['responses']),
                        sectionsSpace: 2,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(List responses) {
    return responses.map<PieChartSectionData>((response) {
      return PieChartSectionData(
        value: double.parse(response['value'].toString()),
        title: '${response['label']} (${response['value']})',
        color: _getColor(response['label']),
        radius: 50,
      );
    }).toList();
  }

  List<BarChartGroupData> _buildBarGroups(List responses) {
    List<BarChartGroupData> barGroups = [];
    int x = 0;
    for (var response in responses) {
      barGroups.add(
        BarChartGroupData(
          x: x++,
          barRods: [
            BarChartRodData(
              toY: double.parse(response['value'].toString()),
              color: _getColor(response['label']),
              width: 15,
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  Color _getColor(String label) {
    switch (label) {
      case 'Python':
        return Colors.blue;
      case 'Java':
        return Colors.red;
      case 'C++':
        return Colors.green;
      case 'JavaScript':
        return Colors.yellow;
      case 'Flutter':
        return Colors.purple;
      case 'React Native':
        return Colors.orange;
      case 'Xamarin':
        return Colors.grey;
      case 'AWS':
        return Colors.amber;
      case 'Azure':
        return Colors.blueAccent;
      case 'Google Cloud':
        return Colors.greenAccent;
      case 'Skipped':
        return Colors.black54; // Color for skipped responses
      default:
        return Colors.black;
    }
  }
}
