import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/http/db.dart';
import 'package:survey_monkey/widgets/appbars.dart';
import 'package:survey_monkey/widgets/spacers.dart';
import 'package:survey_monkey/constants.dart';

class PendingApproval extends StatefulWidget {
  const PendingApproval({Key? key}) : super(key: key);

  @override
  _PendingApprovalState createState() => _PendingApprovalState();
}

class _PendingApprovalState extends State<PendingApproval> {
  late Future<List<dynamic>> _futureSurveys;

  @override
  void initState() {
    super.initState();
    _futureSurveys =
        Db().getAllSurveys(userType: 'admin'); // Initialize the future
  }

  void _refreshSurveys() {
    setState(() {
      _futureSurveys =
          Db().getAllSurveys(userType: 'admin'); // Refresh the list of surveys
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pending Approval Surveys')),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Surveys Pending Approval",
              style: TextStyle(fontSize: 20, color: ck.x),
            ),
            gap20(),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _futureSurveys,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error.toString()}");
                  } else if (snapshot.hasData) {
                    return _list(snapshot.data!);
                  } else {
                    return Text("No data available");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(List<dynamic> surveys) {
    return ListView.builder(
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        var data = surveys[index];
        return Column(
          children: [
            Card(
              child: ListTile(
                title: Text("${data['name']}"),
                subtitle: Text(
                    "Status: ${data['approved'] == 1 ? 'Approved' : 'Pending'}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        bool success = await Db()
                            .approveSurvey(surveyId: data['id'], approved: 1);
                        if (success) {
                          _refreshSurveys();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        bool success = await Db()
                            .acceptRejectSurvey(id: data['id'], approved: 0);
                        if (success) {
                          _refreshSurveys();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
