import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/http/db.dart';

import '../../widgets/appbars.dart';
import '../../widgets/spacers.dart';

class AddQuestionMcqs extends StatefulWidget {
  final int id;
  const AddQuestionMcqs({super.key, required this.id});

  @override
  State<AddQuestionMcqs> createState() => _AddQuestionMcqsState();
}

class _AddQuestionMcqsState extends State<AddQuestionMcqs> {
  TextEditingController q = TextEditingController();
  TextEditingController o1 = TextEditingController();
  TextEditingController o2 = TextEditingController();
  TextEditingController o3 = TextEditingController();
  TextEditingController o4 = TextEditingController();

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
              TextField(
                controller: o1,
                decoration: const InputDecoration(
                  hintText: "Option 1",
                ),
              ),
              gap20(),
              TextField(
                controller: o2,
                decoration: const InputDecoration(hintText: "Option 2"),
              ),
              gap20(),
              TextField(
                controller: o3,
                decoration: const InputDecoration(hintText: "Option 3"),
              ),
              gap20(),
              TextField(
                controller: o4,
                decoration: const InputDecoration(hintText: "Option 4"),
              ),
              gap20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Db().addMcq(
                          title: q.text,
                          id: widget.id,
                          op1: o1.text,
                          op2: o2.text,
                          op3: o3.text,
                          op4: o4.text,
                          isMore: true);

                      setState(() {
                        q.text = '';
                        o1.text = '';
                        o2.text = '';
                        o3.text = '';
                        o4.text = '';
                      });
                    },
                    child: const Text("Add More"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Db().addMcq(
                          title: q.text,
                          id: widget.id,
                          op1: o1.text,
                          op2: o2.text,
                          op3: o3.text,
                          op4: o4.text,
                          isMore: false);
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
