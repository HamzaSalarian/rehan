import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';
import 'package:survey_monkey/widgets/spacers.dart';
import 'package:survey_monkey/widgets/textfields.dart';
import './addQuestionMcqs.dart';
import './addQuestionYesNo.dart';
import '../../widgets/appbars.dart';

class CreateSurveyScreen extends StatefulWidget {
  const CreateSurveyScreen({super.key});

  @override
  _CreateSurveyScreenState createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  TextEditingController nameController = TextEditingController();
  int radioValue = 2; // Default to MCQs
  String selectedOption = 'M'; // Default to 'M'
  String visibility = 'private'; // Default to private

  void handleRadioValueChange(int value) {
    setState(() {
      radioValue = value;
    });
  }

  void handleVisibilityChange(String value) {
    setState(() {
      visibility = value;
    });
  }

  void handleGenderChange(String value) {
    setState(() {
      selectedOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create New Survey")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            textField("Survey Name", nameController),
            gap20(),
            Text("Select Survey Type:"),
            ListTile(
              title: const Text('MCQs'),
              leading: Radio(
                value: 2,
                groupValue: radioValue,
                onChanged: (int? value) {
                  handleRadioValueChange(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Yes/No'),
              leading: Radio(
                value: 1,
                groupValue: radioValue,
                onChanged: (int? value) {
                  handleRadioValueChange(value!);
                },
              ),
            ),
            gap20(),
            Text("Survey Visibility:"),
            ListTile(
              title: const Text('Private'),
              leading: Radio(
                value: 'private',
                groupValue: visibility,
                onChanged: (String? value) {
                  handleVisibilityChange(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Public'),
              leading: Radio(
                value: 'public',
                groupValue: visibility,
                onChanged: (String? value) {
                  handleVisibilityChange(value!);
                },
              ),
            ),
            gap20(),
            Text("Target Gender:"),
            ListTile(
              title: const Text('Male'),
              leading: Radio(
                value: 'M',
                groupValue: selectedOption,
                onChanged: (String? value) {
                  handleGenderChange(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio(
                value: 'F',
                groupValue: selectedOption,
                onChanged: (String? value) {
                  handleGenderChange(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Both'),
              leading: Radio(
                value: 'B',
                groupValue: selectedOption,
                onChanged: (String? value) {
                  handleGenderChange(value!);
                },
              ),
            ),
            gap20(),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedOption.isNotEmpty &&
                    visibility.isNotEmpty) {
                  var result = await Db().createSurvey(
                    name: nameController.text,
                    type: radioValue == 2 ? 'MCQs' : 'Yes/No',
                    sex: selectedOption,
                  );
                  if (result['success']) {
                    int surveyId = result['surveyId'];
                    if (radioValue == 2) {
                      Get.to(() => AddQuestionMcqs(id: surveyId));
                    } else {
                      Get.to(() => AddQuestionYesNo(id: surveyId));
                    }
                  } else {
                    Get.snackbar(
                        "Error", "Failed to create survey: ${result['error']}");
                  }
                } else {
                  Get.snackbar(
                      "Error", "Please fill out all fields before proceeding.");
                }
              },
              child: Text("Create Survey"),
            ),
          ],
        ),
      ),
    );
  }
}
