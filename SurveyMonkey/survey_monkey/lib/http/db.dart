// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/Helper/ActiveSurvey.dart';
import 'package:survey_monkey/Helper/Graph.dart';
import 'package:survey_monkey/Helper/TaskModel.dart';
import 'package:survey_monkey/Helper/Teacher.dart';
import 'package:survey_monkey/Helper/User.dart';
import 'package:survey_monkey/screens/AdminScreen/addQuestion.dart';
import 'package:survey_monkey/screens/AdminScreen/main.dart';
import 'package:survey_monkey/screens/adminHome.dart';
import 'package:survey_monkey/screens/previousSurvey.dart';
import 'package:survey_monkey/screens/userHome.dart';
import '../Helper/Answers.dart';
import '../screens/survey/addQuestionMcqs.dart';
import '../screens/survey/addQuestionYesNo.dart';

class Db {
  final _dio = Dio();
  final _ip = '192.168.100.21';

  Db() {
    _dio.options.baseUrl = 'http://$_ip:5000/api/';
  }

  Future login({required id, required password}) async {
    try {
      print('clicked.........${_dio.options.baseUrl}');
      var res = await _dio.get('login?id=$id&password=$password');
      if (res.data['UserType'] == 'Student') {
        User.id = res.data['Data']['Reg_No'];
        User.name = res.data['Data']['St_firstname'];
        User.discipline = res.data['Data']['Discipline'];
        User.semesterNo = res.data['Data']['Semester_no'];
        User.section = res.data['Data']['Section'];
        User.sex = res.data['Data']['Sex'];
        Get.to(() => const UserHome());
      } else if (res.data['Data']['Roles'] == 'Admin') {
        User.id = res.data['Data']['Emp_no'];
        User.name = res.data['Data']['Emp_firstname'];
        User.sex = res.data['Data']['sex'];
        User.discipline = '';
        User.semesterNo = '';
        User.section = '';
        Get.to(() => const AdminHome());
      } else {
        User.id = res.data['Data']['Emp_no'];
        User.name = res.data['Data']['Emp_firstname'];
        User.sex = res.data['Data']['sex'];
        User.discipline = '';
        User.semesterNo = '';
        User.section = '';
        Get.to(() => const UserHome());
      }
    } catch (ex) {
      print('error loggin in ---> :$ex');
    }
  }

  Future<Map<String, dynamic>> createSurvey(
      {required String name, required String type, required String sex}) async {
    Map<String, dynamic> result = {
      'success': false,
      'surveyId': -1 // Default to -1 or null if you prefer
    };

    try {
      var response = await _dio.post('createSurvey', data: {
        'name': name,
        'type': type,
        'createdby': User.id,
        'approved': User.approved,
        'status': User.selectedOption,
        'sex': sex,
      });

      if (response.statusCode == 200) {
        result['success'] = true;
        result['surveyId'] = response.data[
            'id']; // Assuming 'id' is returned by your server in the response
      }
    } catch (e) {
      print("Error creating survey: $e");
    }

    return result;
  }

  Future addQuestion({required q, required id, required bool isMore}) async {
    try {
      await _dio.post('addQuestion', data: {
        'title': q,
        'option1': 'yes',
        'option2': 'no',
        'surveyid': id,
      });

      if (!isMore) {
        if (User.discipline == '') {
          Get.to(() => const AdminHome());
        } else {
          Get.to(() => const UserHome());
        }
      }
    } catch (ex) {
      print('error:$ex');
    }
  }

  // function to get Approved surveys for the user.

  Future<List<dynamic>> getApprovedSurveys(String userId) async {
    try {
      var response = await _dio
          .get('getApprovedSurveys', queryParameters: {'userId': userId});
      if (response.statusCode == 200) {
        // Make sure to check if the data is a list before casting
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else {
          print('Data received is not a list');
          return [];
        }
      } else {
        print(
            'Failed to load approved surveys with status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching approved surveys: $e');
      return []; // Return an empty list on exception
    }
  }

  Future<void> addMcq({
    required String title,
    required int id,
    required String op1,
    required String op2,
    required String op3,
    required String op4,
    required bool isMore,
  }) async {
    try {
      final response = await _dio.post('addQuestion', data: {
        'surveyid': id,
        'question': title,
        'option1': op1,
        'option2': op2,
        'option3': op3,
        'option4': op4,
      });

      if (response.statusCode == 200) {
        if (!isMore) {
          if (User.discipline.isEmpty) {
            Get.off(() => const AdminHome());
          } else {
            Get.off(() => const UserHome());
          }
        }
      } else {
        Get.snackbar("Error",
            "Failed to add question: ${response.data['Message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print('Error adding MCQ: $e');
      Get.snackbar("Error", "Exception occurred: $e");
    }
  }

  Future<List<dynamic>> getParticipateSurveys() async {
    try {
      var response = await _dio.get('getParticipateSurveys');

      if (response.statusCode == 200) {
        // Make sure to check if the data is a list before casting
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else {
          print('Data received is not a list');
          return [];
        }
      } else {
        print(
            'Failed to load approved surveys with status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching approved surveys: $e');
      return []; // Return an empty list on exception
    }
  }

  Future surveyByApproved({required ap, required status}) async {
    try {
      print("CALLED${User.sex}");
      var rs = await _dio.get('surveyByApproved', queryParameters: {
        'ap': ap,
        'Discipline': User.discipline,
        'Section': User.section,
        'Semester_no': User.semesterNo,
        'status': status,
        'sex': User.sex
      });
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  //aprove survey

  Future<bool> approveSurvey(
      {required int surveyId, required int approved}) async {
    try {
      var response = await _dio
          .post('approveSurvey', data: {'id': surveyId, 'approved': approved});

      if (response.statusCode == 200) {
        print('Survey approval status updated successfully: ${response.data}');
        return true;
      } else {
        print(
            'Failed to update survey approval status: ${response.statusCode} - ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error updating survey approval status: $e');
      return false;
    }
  }

  //getAll surveys

  // Method to fetch all surveys from the backend
  Future<List<dynamic>> getAllSurveys({String userType = 'user'}) async {
    try {
      var response = await _dio
          .get('getAllSurveys', queryParameters: {'user_type': userType});
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(
            'Failed to load surveys with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching surveys: $e');
      return []; // Return an empty list in case of exceptions
    }
  }

  //these are conducted surves
  Future surveyNotApproved() async {
    try {
      var rs = await _dio.get('surveyNotApproved');
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future results({String gender = 'All', String discipline = 'All'}) async {
    try {
      var rs = await _dio.get('results', queryParameters: {
        'gender': gender,
        'discipline': discipline,
      });
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
      return [];
    }
  }

  Future totalQuestions(var id) async {
    try {
      var rs = await _dio.get('totalQuestions?id=$id');
      var res = rs.data;
      return res;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future acceptRejectSurvey({required id, required approved}) async {
    try {
      await _dio.post('acceptRejectSurvey?id=$id&approved=$approved');
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future surveyQuestion({required id}) async {
    try {
      var rs = await _dio.get('surveyQuestion?id=$id');
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future submitSurveyAnswers({required List<Answers> ans}) async {
    try {
      DateTime today = DateTime.now();
      DateTime todayDate = DateTime(today.year, today.month, today.day);
      for (var i in ans) {
        await _dio.post('submitSurveyAnswers', data: {
          'surveyid': User.tempSurveyId,
          'questionid': i.qid,
          'response': i.response,
          'userid': User.id,
          'date': todayDate.toString(),
        });
      }

      Get.back();
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future calculateGraph({
    required int sid,
    String gender = 'All',
    String discipline = 'All',
  }) async {
    try {
      var rs = await _dio.get('calculateGraph', queryParameters: {
        'sid': sid,
        'gender': gender,
        'discipline': discipline,
      });

      // Assuming the API returns a list with four elements representing the graph data
      Graph.v1 = rs.data[0];
      Graph.v2 = rs.data[1];
      Graph.v3 = rs.data[2];
      Graph.v4 = rs.data[3];
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future<List<String>> getDiscipline() async {
    try {
      var rs = await _dio.get('getDiscipline');
      return (rs.data as List).cast<String>();
    } catch (ex) {
      print('error:$ex');
      return [];
    }
  }

  Future getSection() async {
    try {
      var rs = await _dio.get('getSection?discipline=${User.tempDiscipline}');
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
      return [];
    }
  }

  Future addActiveSurvey({required List<ActiveSurvey> survey}) async {
    try {
      for (var i in survey) {
        await _dio.post('addActiveSurvey', data: {
          'sid': User.tempSurveyId,
          'startDate': User.tempStartDate.toString(),
          'endDate': User.tempEndDate.toString(),
          'section': i.section.toString(),
          'semester': i.semester.toString(),
          'discipline': User.tempDiscipline.toString()
        });
      }
      Get.to(() => const PreviousSurvey());
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future<List<Teacher>> getTeachers() async {
    try {
      var res = await _dio.get('getTeachers');

      List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(res.data);

      List<Teacher> fetchedTeachers = responseData.map((i) {
        return Teacher(
          empno: i['Emp_no'].toString(),
          name: "${i['Emp_firstname']} ${i['Emp_lastname']}",
        );
      }).toList();

      return fetchedTeachers;
    } catch (ex) {
      print('error: $ex');
      return [];
    }
  }

  Future createTeacherSurvey({required name, required tid}) async {
    try {
      var res = await _dio.post('createTeacherSurvey', data: {
        'name': name,
        'createdby': User.id,
        'tid': tid,
      });

      Get.to(() => AddQuestion(
            id: res.data,
          ));
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future addTeacherQuestion({required title, required id}) async {
    try {
      await _dio.post('addQuestion', data: {
        'title': title,
        'option1': 'Excellent',
        'option2': 'Good',
        'option3': 'Bad',
        'option4': 'Worse',
        'surveyid': id,
      });

      Get.to(() => const MainHome());
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future teachersSurveyList() async {
    try {
      var rs = await _dio
          .get('teachersSurveyList', queryParameters: {'tid': User.id});
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future calculateTeacherGraph({required sid}) async {
    try {
      var rs = await _dio.get('calculateTeacherGraph?sid=$sid');
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future surveyQuestions(var id) async {
    try {
      print("CALLED${User.sex}");
      var rs = await _dio.get('surveyQuestions', queryParameters: {
        'id': id,
      });
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future getSurveyHistory() async {
    try {
      var res = await _dio.get('getSurveyHistory');
      return res.data as List;
    } catch (ex) {
      print('error:$ex');
      return [];
    }
  }

  Future result(var sid) async {
    try {
      var rs = await _dio.get('result', queryParameters: {'sid': sid});
      return rs.data as List;
    } catch (ex) {
      print('error:$ex');
    }
  }

  Future<Map<String, dynamic>> task() async {
    try {
      var response = await _dio.get('task');
      var data = response.data as Map<String, dynamic>;

      List<Student> students = (data['Students'] as List)
          .map((json) => Student.fromJson(json))
          .toList();

      List<Survey> surveys = (data['Surveys'] as List)
          .map((json) => Survey.fromJson(json))
          .toList();

      return {
        'students': students,
        'surveys': surveys,
      };
    } catch (ex) {
      print('Error: $ex');
      return {};
    }
  }
}
