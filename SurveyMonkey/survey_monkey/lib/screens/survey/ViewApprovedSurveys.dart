import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/http/db.dart';
import './addQuestionMcqs.dart'; // Ensure this path is correct
import './addQuestionYesNo.dart'; // Ensure this path is correct

class ViewApprovedSurveys extends StatefulWidget {
  const ViewApprovedSurveys({Key? key}) : super(key: key);

  @override
  _ViewApprovedSurveysState createState() => _ViewApprovedSurveysState();
}

class _ViewApprovedSurveysState extends State<ViewApprovedSurveys> {
  late Future<List<dynamic>> surveysFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the approved surveys for the user using their User ID
    surveysFuture = Db().getApprovedSurveys(User.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approved Surveys'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: surveysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var survey = snapshot.data![index];
                return ListTile(
                  title: Text(survey['name']),
                  subtitle: Text('Type: ${survey['type']}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    if (survey['type'].toString().trim() == 'MCQs') {
                      Get.to(() => AddQuestionMcqs(id: survey['id']));
                    } else {
                      Get.to(() => AddQuestionYesNo(id: survey['id']));
                    }
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No approved surveys available'));
          }
        },
      ),
    );
  }
}
