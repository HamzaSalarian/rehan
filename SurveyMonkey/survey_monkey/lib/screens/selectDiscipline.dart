// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/http/db.dart';
import 'package:survey_monkey/screens/selectSection.dart';
import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

class SelectDiscipline extends StatefulWidget {
  const SelectDiscipline({super.key});

  @override
  State<SelectDiscipline> createState() => _SelectDisciplineState();
}

class _SelectDisciplineState extends State<SelectDiscipline> {
  late Future<List<String>> _future;

  //late List<bool> _selectedDisciplines;
  final List<bool> _selectedDisciplines = List.generate(100, (index) => false);

  @override
  void initState() {
    super.initState();
    _future = Db().getDiscipline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const Text(
              "Select Discipline",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            gap20(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _futureBuild(),
            ),
            gap20(),
            ElevatedButton(
              onPressed: () {
                Get.to(const SelectSection());
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _futureBuild() {
    return FutureBuilder<List<String>>(
      future: _future,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          // _selectedDisciplines =
          //     List.generate(snapshot.data!.length, (index) => false);
          return _list(snapshot);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _list(AsyncSnapshot<List<String>> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              String? discipline = snapshot.data?[index];

              return CheckboxListTile(
                title: Text(discipline ?? ''),
                value: _selectedDisciplines[index],
                onChanged: (newValue) {
                  setState(() {
                    _selectedDisciplines[index] = newValue!;
                    User.tempDiscipline = discipline!;
                  });
                  Get.to(const SelectSection());
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        ),
      ],
    );
  }
}
