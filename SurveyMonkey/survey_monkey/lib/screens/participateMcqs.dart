import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/Answers.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/widgets/appbars.dart';
import 'package:survey_monkey/widgets/spacers.dart';

import '../Helper/User.dart';
import '../http/db.dart';

class ParticipateMCQs extends StatefulWidget {
  const ParticipateMCQs({super.key});

  @override
  State<ParticipateMCQs> createState() => _ParticipateMCQsState();
}

class _ParticipateMCQsState extends State<ParticipateMCQs> {
  late Future _future;
  List<List<bool?>> isCheckedList = [];
  List<Answers> ans = [];
  List<int> skippedQuestions = []; // List to track skipped questions
  int currentQuestionIndex = 0; // Track current question index

  @override
  void initState() {
    super.initState();
    _future = Db().surveyQuestion(id: User.tempSurveyId);
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
            Expanded(child: _futureBuild()),
            _actionButtons(),
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
    Map data = snapshot.data[currentQuestionIndex];

    if (isCheckedList.length <= currentQuestionIndex) {
      isCheckedList.add(List.generate(4, (_) => false));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}:",
          style: TextStyle(
            fontSize: 16,
            color: ck.x,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(data['title']),
        buildRow(data['option1'], currentQuestionIndex, 0, data),
        buildRow(data['option2'], currentQuestionIndex, 1, data),
        buildRow(data['option3'], currentQuestionIndex, 2, data),
        buildRow(data['option4'], currentQuestionIndex, 3, data),
        gap20(),
      ],
    );
  }

  Widget buildRow(
      String option, int questionIndex, int checkboxIndex, Map data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: isCheckedList[questionIndex][checkboxIndex],
          onChanged: (value) {
            setState(() {
              if (skippedQuestions.contains(questionIndex))
                return; // Do not allow selection if skipped

              isCheckedList[questionIndex][checkboxIndex] = value;

              var t = Answers(
                qid: data['id'],
                response: option,
                isSkipped: false,
              );

              bool isAlreadyInList = ans.any((element) =>
                  element.qid == t.qid && element.response == t.response);

              if (value == true && !isAlreadyInList) {
                ans.add(t);
              } else if (value == false && isAlreadyInList) {
                ans.removeWhere((element) =>
                    element.qid == t.qid && element.response == t.response);
              }
            });
          },
        ),
        Text(option),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _handleSubmitOrSkip(); // Handle submission and go to next question
          },
          child: const Text("Submit"),
        ),
        ElevatedButton(
          onPressed: () {
            _handleSubmitOrSkip(
                isSkip: true); // Handle skip and go to next question
          },
          child: const Text("Skip"),
        ),
      ],
    );
  }

  Future<void> _handleSubmitOrSkip({bool isSkip = false}) async {
    setState(() async {
      Map data =
          await _future.then((snapshot) => snapshot[currentQuestionIndex]);

      if (isSkip) {
        skippedQuestions.add(currentQuestionIndex); // Mark question as skipped
        isCheckedList[currentQuestionIndex] =
            List.generate(4, (_) => false); // Uncheck all options
        print('Question ${currentQuestionIndex + 1} has been skipped');
      } else {
        // If submitting, make sure answers are collected
        var selectedAnswers = isCheckedList[currentQuestionIndex];
        for (int i = 0; i < selectedAnswers.length; i++) {
          if (selectedAnswers[i] == true) {
            var answer = Answers(
              qid: data['id'],
              response: data['option${i + 1}'],
              isSkipped: false,
            );
            ans.add(answer);
          }
        }
      }

      // Go to the next question or submit if it's the last one
      if (currentQuestionIndex < isCheckedList.length - 1) {
        currentQuestionIndex++;
      } else {
        _submitSurvey(); // Submit the survey if it's the last question
      }
    });
  }

  void _submitSurvey() async {
    if (ans.isNotEmpty || skippedQuestions.isNotEmpty) {
      // Add skipped questions to the answer list
      for (int index in skippedQuestions) {
        var skippedAnswer = Answers(
          qid: await _future
              .asStream()
              .first
              .then((snapshot) => snapshot[index]['id']),
          response: 'Skipped',
          isSkipped: true,
        );
        ans.add(skippedAnswer);
      }

      await Db().submitSurveyAnswers(ans: ans);
      // Handle survey submission, e.g., show a completion message or navigate away
      print('Survey submitted successfully');
    } else {
      print('Nothing to submit');
    }
  }
}
