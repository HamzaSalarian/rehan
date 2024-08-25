import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';

import '../widgets/appbars.dart';
import '../widgets/spacers.dart';

class PendingApproval extends StatefulWidget {
  const PendingApproval({super.key});

  @override
  State<PendingApproval> createState() => _PendingApprovalState();
}

class _PendingApprovalState extends State<PendingApproval> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    _future = Db().surveyByApproved(ap: 1, status: 'private');
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
              "Pending Approval",
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
      },
    );
  }

  Widget _list(AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, i) {
        Map data = snapshot.data[i];
        return data['approved']=='1'? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${data['name']}"),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await Db()
                            .acceptRejectSurvey(id: data['id'], approved: 1);
                        setState(() {
                          _fetchData();
                        });
                      },
                      color: ck.x,
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Db()
                            .acceptRejectSurvey(id: data['id'], approved: 2);
                        setState(() {
                          _fetchData();
                        });
                      },
                      color: Colors.red,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
            gap20(),
          ],
        ) : Container();
      },
    );
  }
}
