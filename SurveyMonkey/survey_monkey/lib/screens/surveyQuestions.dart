// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';

import 'package:survey_monkey/screens/graphs/pieChart.dart';

import '../http/db.dart';
import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

// ignore: must_be_immutable
class SurveyQuestion extends StatefulWidget {
  SurveyQuestion({super.key});

  // ignore: prefer_typing_uninitialized_variables
  var id, surveyId, data;
  SurveyQuestion.set({super.key, this.id, this.surveyId, this.data});
  @override
  State<SurveyQuestion> createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Db().surveyQuestion(id: widget.surveyId);
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
              "Questions",
              style: TextStyle(fontSize: 20, color: ck.x),
            ),
            gap20(),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _list(AsyncSnapshot snapshot) {
    return Column(
      children: [
        FutureBuilder(
          future: Db().totalQuestions(widget.surveyId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var snap = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {}
            try {
              return Text("Total Questions : ${snap[0]['total'].toString()}");
            } catch (e) {
              return Container();
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, i) {
            Map data = snapshot.data[i];
            print(data);
            return GestureDetector(
              onTap: () => Get.to(() => PieChart(
                  id: widget.surveyId, data: widget.data, status: true)),
              child: Container(
                color: ck.x,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${data['title']}"),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
