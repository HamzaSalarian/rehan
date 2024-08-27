import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ViewApprovedSurveys.dart'; // Import without alias if not needed
import 'CreateSurveyScreen.dart'; // Import the CreateSurveyScreen

class AddName extends StatelessWidget {
  const AddName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Survey Options")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => const CreateSurveyScreen()),
              child: Text("Create New Survey"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const ViewApprovedSurveys()),
              child: Text("Add Questions to Approved Surveys"),
            ),
          ],
        ),
      ),
    );
  }
}
