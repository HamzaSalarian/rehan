import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';
import 'package:survey_monkey/widgets/spacers.dart';
import 'package:survey_monkey/widgets/textfields.dart';

import '../../widgets/appbars.dart';

class AddName extends StatefulWidget {
  const AddName({super.key});

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  TextEditingController name = TextEditingController();
  int radioValue = 2;
  String selectedOption = '';
  handleRadioValueChange(int value) {
    setState(() {
      radioValue = value;
    });
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
              "Create New Survey",
              style: TextStyle(
                  fontSize: 20, color: ck.x, fontWeight: FontWeight.w800),
            ),
            gap20(),
            textField("Name", name),
            gap20(),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Template")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 1,
                  groupValue: radioValue,
                  onChanged: (value) {
                    handleRadioValueChange(1);
                  },
                ),
                const Text(
                  'True / False',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  value: 2,
                  groupValue: radioValue,
                  onChanged: (value) {
                    handleRadioValueChange(2);
                  },
                ),
                const Text(
                  'MCQs',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            gap20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: 'private',
                  groupValue: User.selectedOption,
                  onChanged: (value) {
                    User.selectedOption = value!;
                    User.approved = 1;
                    setState(() {});
                  },
                ),
                const Text('private'),
                Radio(
                  value: 'public',
                  groupValue: User.selectedOption,
                  onChanged: (value) {
                    User.selectedOption = value!;
                    User.approved = 1;
                    setState(() {});
                  },
                ),
                const Text('public'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'M',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                const Text('Male'),
                Radio(
                  value: 'F',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                const Text('Female'),
                Radio(
                  value: 'B',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                const Text('Both'),
              ],
            ),
            gap20(),
            ElevatedButton(
              onPressed: () {
                if (User.selectedOption != '' && selectedOption != '') {
                  if (radioValue == 2) {
                    Db().createSurvey(
                        name: name.text, type: 'MCQS', sex: selectedOption);
                  } else {
                    Db().createSurvey(
                        name: name.text, type: 'Yes/No', sex: selectedOption);
                  }
                } else {
                  print('<--Select private or public--->');
                }
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
