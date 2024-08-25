import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/http/db.dart';

import '../../widgets/appbars.dart';
import '../../widgets/spacers.dart';

class AddQuestionYesNo extends StatefulWidget {
  final int id;
  const AddQuestionYesNo({super.key, required this.id});

  @override
  State<AddQuestionYesNo> createState() => _AddQuestionYesNoState();
}

class _AddQuestionYesNoState extends State<AddQuestionYesNo> {
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
                "Add New Question",
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
                    onPressed: () {
                      Db().addQuestion(q: q.text, id: widget.id, isMore: true);
                      setState(() {
                        q.text = '';
                      });
                    },
                    child: const Text("Add More"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Db().addQuestion(q: q.text, id: widget.id, isMore: false);
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
