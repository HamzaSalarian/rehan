import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/http/db.dart';

import '../../widgets/appbars.dart';
import '../../widgets/spacers.dart';

class AddQuestion extends StatefulWidget {
  final int id;
  const AddQuestion({super.key, required this.id});

  @override
  State<AddQuestion> createState() => _AddQuestionYesNoState();
}

class _AddQuestionYesNoState extends State<AddQuestion> {
  TextEditingController q = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              gap20(),
              const Text(
                "Add Question",
                style: TextStyle(fontSize: 26),
              ),
              gap20(),
              TextField(
                controller: q,
                decoration: const InputDecoration(
                    hintText: "Question", border: OutlineInputBorder()),
                minLines: 4,
                maxLines: 5,
              ),
              gap20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Db()
                          .addTeacherQuestion(title: q.text, id: widget.id);
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
