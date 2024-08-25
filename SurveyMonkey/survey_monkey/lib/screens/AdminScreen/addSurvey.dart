import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:survey_monkey/constants.dart';

import 'package:survey_monkey/widgets/spacers.dart';
import 'package:survey_monkey/widgets/textfields.dart';

import '../../Helper/Teacher.dart';
import '../../http/db.dart';
import '../../widgets/appbars.dart';

class AddSurvey extends StatefulWidget {
  const AddSurvey({super.key});

  @override
  State<AddSurvey> createState() => _AddSurveyState();
}

class _AddSurveyState extends State<AddSurvey> {
  TextEditingController name = TextEditingController();
  List<Teacher> teachers = [];
  Teacher? selectedTeacher;

  @override
  void initState() {
    super.initState();
    fetchTeachersData();
  }

  Future<void> fetchTeachersData() async {
    List<Teacher> fetchedTeachers = await Db().getTeachers();
    setState(() {
      teachers = fetchedTeachers;
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
              "Create Teacher Survey",
              style: TextStyle(
                  fontSize: 20, color: ck.x, fontWeight: FontWeight.w800),
            ),
            gap20(),
            textField("Name", name),
            gap20(),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Template")),
            Center(
              child: DropdownButton<Teacher>(
                value: selectedTeacher,
                onChanged: (Teacher? newValue) {
                  setState(() {
                    selectedTeacher = newValue;
                  });
                },
                items: teachers.map<DropdownMenuItem<Teacher>>((Teacher value) {
                  return DropdownMenuItem<Teacher>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTeacher != null) {
                  Db().createTeacherSurvey(
                      name: name.text, tid: selectedTeacher!.empno);
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
