import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';

import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

class ApprovedApproval extends StatefulWidget {
  const ApprovedApproval({super.key});

  @override
  State<ApprovedApproval> createState() => _ApprovedApprovalState();
}

class _ApprovedApprovalState extends State<ApprovedApproval> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Db().surveyByApproved(ap: 1, status: 'public');
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
              "Approved Approval",
              style: TextStyle(fontSize: 20, color: ck.x),
            ),
            gap20(),
            Expanded(
              child: _futureBuild(),
            ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _list(AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, i) {
        Map data = snapshot.data[i];
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${data['name']}"),
              ],
            ),
            gap20(),
          ],
        );
      },
    );
  }
}
