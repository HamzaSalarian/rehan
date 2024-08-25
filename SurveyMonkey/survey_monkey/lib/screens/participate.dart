import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/screens/participateMcqs.dart';
import 'package:survey_monkey/screens/participateYesNo.dart';

import '../Helper/User.dart';
import '../http/db.dart';
import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

class Participate extends StatefulWidget {
  const Participate({super.key});

  @override
  State<Participate> createState() => _ParticipateState();
}

class _ParticipateState extends State<Participate> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Db().surveyByApproved(ap: 1, status: 'public');
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
              "Participate",
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (context, i) {
          Map data = snapshot.data[i];
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${data['name']}"),
                  ElevatedButton(
                    onPressed: () {
                      User.tempSurveyId = data['id'];
                      if (data['type'] == 'MCQS') {
                        Get.to(() => const ParticipateMCQs());
                      } else {
                        Get.to(() => const ParticipateYesNo());
                      }
                    },
                    child: const Text("Attempt"),
                  )
                ],
              ),
              gap20(),
            ],
          );
        });
  }
}
