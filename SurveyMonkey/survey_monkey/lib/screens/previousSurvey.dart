// ignore: file_names
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/screens/selectDiscipline.dart';
import 'package:survey_monkey/widgets/appbars.dart';
import 'package:survey_monkey/widgets/spacers.dart';

import '../http/db.dart';

class PreviousSurvey extends StatefulWidget {
  const PreviousSurvey({super.key});

  @override
  State<PreviousSurvey> createState() => _PreviousSurveyState();
}

class _PreviousSurveyState extends State<PreviousSurvey> {
  var selectedDate = DateTime.now();
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Db().surveyNotApproved();
  }

  Future<void> _selectDate(BuildContext context, DateTime tmp) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        tmp = picked;
      });
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
            Text(
              "Previous Surveys",
              style: TextStyle(fontSize: 20, color: ck.x),
            ),
            Expanded(
              child: _futureBuild(),
            ),
          ],
        ),
      ),
    );
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
          return Column(
            children: [
              gap20(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Select Dates for Survey"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Start Date : ${selectedDate.year.toString()}-${selectedDate.month.toString()}-${selectedDate.day.toString()}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectDate(context, User.tempStartDate);
                                    },
                                    child: const Text('Select'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'End Date : ${selectedDate.year.toString()}-${selectedDate.month.toString()}-${selectedDate.day.toString()}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectDate(context, User.tempEndDate);
                                    },
                                    child: const Text('Select'),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  User.tempSurveyId = data['id'];

                                  Get.to(const SelectDiscipline());
                                },
                                child: const Text("Next"),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  // Navigator.pop(context);

                  // Get.to(const SelectDiscipline());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data['name']),
                      const Text(
                        "Inactive",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
