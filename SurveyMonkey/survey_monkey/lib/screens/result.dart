import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
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

class Result extends StatefulWidget {
  final int sid;
  const Result({super.key, required this.sid});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future _future;
  @override
  void initState() {
    super.initState();
    _future = Db().result(widget.sid);
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
              "Result",
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
          /////
          onTap: () {
            Get.to(SurveyQuestion.set(
              id: data['id'],
              surveyId: widget.sid,
              data: data,
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
                      onPressed: () {
                        //Get.to(() => BarChartWidget());
                        //id: data['id'], data: data
                      },
                      color: ck.x,
                      icon: const Icon(Icons.bar_chart),
                    ),
                    IconButton(
                      onPressed: () {
                        //Get.to(() => PieChartWidget(
                        // id: data['id'],
                        // data: data,
                        // status: false,
                        // ));
                      },
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
}
