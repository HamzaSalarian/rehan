import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/Answers.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/widgets/appbars.dart';
import 'package:survey_monkey/widgets/spacers.dart';

import '../../Helper/User.dart';
import '../../http/db.dart';

class Participate extends StatefulWidget {
  const Participate({super.key});

  @override
  State<Participate> createState() => _ParticipateState();
}

class _ParticipateState extends State<Participate> {
  late Future _future;
  List<List<bool?>> isCheckedList = [];
  List<Answers> ans = [];
  List<int> skippedQuestions = []; // List to track skipped questions
  int currentQuestionIndex = 0; // Track the current question index

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
            Expanded(
              child: _futureBuild(),
            ),
            _actionButtons()
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
        ElevatedButton(
          onPressed: () {
            _skipQuestion();
          },
          child: const Text("Skip"),
        ),
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
              if (skippedQuestions.contains(questionIndex)) return;

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
          onPressed: _submitAnswer,
          child: const Text("Submit"),
        ),
        ElevatedButton(
          onPressed: _skipQuestion,
          child: const Text("Skip"),
        ),
      ],
    );
  }

  void _skipQuestion() {
    setState(() {
      skippedQuestions.add(currentQuestionIndex); // Mark question as skipped
      isCheckedList[currentQuestionIndex] =
          List.generate(4, (_) => false); // Uncheck all options
      _goToNextQuestion();
      print('Question ${currentQuestionIndex + 1} has been skipped');
    });
  }

  void _submitAnswer() {
    setState(() async {
      // You can validate answers or handle any other logic before moving to the next question
      _goToNextQuestion();
    });
  }

  void _goToNextQuestion() {
    setState(() {
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
          qid: await _future.then((snapshot) => snapshot[index]['id']),
          response: 'Skipped',
          isSkipped: true,
        );
        ans.add(skippedAnswer);
      }

      await Db().submitSurveyAnswers(ans: ans);
      // Clear the lists after submission to prevent duplicate submissions
      ans.clear();
      skippedQuestions.clear();
      isCheckedList.clear();

      // Handle survey submission success, e.g., show a completion message or navigate away
      print('Survey submitted successfully');
    } else {
      print('Nothing to submit');
    }
  }
}
