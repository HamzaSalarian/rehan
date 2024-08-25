// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/TaskModel.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';

import 'package:survey_monkey/screens/result.dart';
import 'package:survey_monkey/widgets/appbars.dart';

class HistoryTask extends StatefulWidget {
  const HistoryTask({super.key});

  @override
  State<HistoryTask> createState() => _HistoryTaskState();
}

class _HistoryTaskState extends State<HistoryTask> {
  List<Student> students = [];
  List<Survey> surveys = [];
  List<Student> filteredStudents = [];
  List<Survey> filteredSurveys = [];
  String filterSex = '';
  bool sortAsc = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      var data = await Db().task();
      students = data['students'] as List<Student>;
      surveys = data['surveys'] as List<Survey>;
      applyFilter();
    } catch (ex) {
      print('Error fetching data: $ex');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void applyFilter() {
    if (filterSex.isNotEmpty) {
      filteredStudents = students.where((s) => s.sex == filterSex).toList();
      filteredSurveys = surveys.where((s) => s.sex == filterSex).toList();
    } else {
      filteredStudents = students;
      filteredSurveys = surveys;
    }
    if (sortAsc) {
      filteredSurveys.sort((a, b) => a.dTime.compareTo(b.dTime));
    } else {
      filteredSurveys.sort((a, b) => b.dTime.compareTo(a.dTime));
    }
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterSex = 'M';
                        applyFilter();
                      });
                    },
                    child: const Text("Male"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterSex = 'F';
                        applyFilter();
                      });
                    },
                    child: const Text("Female"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterSex = '';
                        applyFilter();
                      });
                    },
                    child: const Text("All"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sortAsc = true;
                        applyFilter();
                      });
                    },
                    child: const Text("Sort Asc"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sortAsc = false;
                        applyFilter();
                      });
                    },
                    child: const Text("Sort Desc"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading ? const CircularProgressIndicator() : _list(),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Text("Students",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...filteredStudents.map((student) => ListTile(
                title: Text(student.stFirstname),
                subtitle: Text('Reg No: ${student.regNo}\nSex: ${student.sex}'),
              )),
          const SizedBox(height: 20),
          const Text("Surveys",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...filteredSurveys.map((survey) => ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(survey.name),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => Result(
                              sid: survey.id,
                            ));
                      },
                      color: ck.x,
                      icon: const Icon(Icons.details),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Created By: ${survey.createdBy}\nSex: ${survey.sex}\nTime: ${survey.dTime}',
                ),
              )),
        ],
      ),
    );
  }
}
