import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/ActiveSurvey.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/http/db.dart';
import 'package:survey_monkey/widgets/appbars.dart';

import '../widgets/spacers.dart';

class SelectSection extends StatefulWidget {
  const SelectSection({super.key});

  @override
  State<SelectSection> createState() => _SelectSectionState();
}

class _SelectSectionState extends State<SelectSection> {
  var isChecked = false;

  late Future _future;
  List<ActiveSurvey> list = [];
  final List<bool> options = List.generate(100, (index) => false);

  @override
  void initState() {
    super.initState();
    _future = Db().getSection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Select Sections",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              gap20(),
              CheckboxListTile(
                title: const Text("Select All"),
                value: isChecked,
                onChanged: (newValue) {},
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              gap20(),
              SizedBox(
                width: Get.width,
                height: Get.height - 350,
                child: _futureBuild(),
              ),
              gap20(),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Radio(
              //       value: 1,
              //       groupValue: '',
              //       onChanged: (value) {
              //         //handleRadioValueChange(1);
              //       },
              //     ),
              //     const Text(
              //       'YES/NO',
              //       style: TextStyle(fontSize: 16.0),
              //     ),
              //     Radio(
              //       value: 2,
              //       groupValue: '',
              //       onChanged: (value) {
              //
              //       },
              //     ),
              //     const Text(
              //       'MCQs',
              //       style: TextStyle(
              //         fontSize: 16.0,
              //       ),
              //     ),
              //   ],
              // ),
              ElevatedButton(
                  onPressed: () async {
                    if (list.isNotEmpty) {
                      await Db().addActiveSurvey(survey: list);
                    }
                  },
                  child: const Text("Next")),
            ],
          ),
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
    return SingleChildScrollView(
      child: ExpansionTile(
        title: CheckboxListTile(
          title: Text(User.tempDiscipline),
          value: false,
          onChanged: (newValue) {},
          controlAffinity: ListTileControlAffinity.leading,
        ),
        children: [
          ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Map data = snapshot.data[index];
                return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: CheckboxListTile(
                      title: Text("${data['CrsSemNo']}-${data['SECTION']}"),
                      value: options[index],
                      onChanged: (newValue) {
                        var ob = ActiveSurvey();
                        ob.semester = data['CrsSemNo'].toString();
                        ob.section = data['SECTION'].toString();
                        if (list.contains(ob)) {
                          list.remove(ob);
                        } else {
                          list.add(ob);
                        }
                        setState(() {
                          options[index] = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ));
              }),
        ],
      ),
    );
  }
}
