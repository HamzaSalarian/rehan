import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/screens/TeacherEvaluation/participateEvaluation.dart';
import 'package:survey_monkey/screens/graphs/historyTask.dart';
import 'package:survey_monkey/screens/participate.dart';
import 'package:survey_monkey/screens/previousSurvey.dart';
import 'package:survey_monkey/screens/results.dart';
import 'package:survey_monkey/screens/survey/addName.dart';

import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int cupertinoTabBarValue = 0;

  int cupertinoTabBarValueGetter() => cupertinoTabBarValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hello!! ${User.name}",
              style: const TextStyle(fontSize: 20),
            ),
            const Text(
              "DASHBOARD",
              style: TextStyle(fontSize: 20),
            ),
            gap20(),
            gap20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const AddName());
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    height: 125,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: ck.x,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "New Survey",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const PreviousSurvey());
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    height: 125,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Previous",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            gap20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Participate());
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    height: 125,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Participate",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Results());
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    height: 125,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: ck.x,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Center(
                        child: Text(
                      "Graph",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                ),
              ],
            ),
            gap20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ParticipateEV());
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    height: 125,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: ck.x,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                        child: Text(
                      "Teacher Evaluation Survey",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                ),

                // Task....//
                GestureDetector(
                  onTap: () {
                    Get.to(() => const HistoryTask());
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    height: 125,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: ck.x,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                        child: Text(
                      "Task",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
