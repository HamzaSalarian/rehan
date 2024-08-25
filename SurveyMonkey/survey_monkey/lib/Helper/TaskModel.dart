// ignore_for_file: file_names

class Student {
  String regNo;
  String appNo;
  String stFirstname;
  String sex;
  String? maritalStatus;
  DateTime birthDate;
  String semesterNo;
  String section;
  String password;
  String discipline;

  Student({
    required this.regNo,
    required this.appNo,
    required this.stFirstname,
    required this.sex,
    this.maritalStatus,
    required this.birthDate,
    required this.semesterNo,
    required this.section,
    required this.password,
    required this.discipline,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      regNo: json['Reg_No'],
      appNo: json['App_no'],
      stFirstname: json['St_firstname'],
      sex: json['Sex'],
      maritalStatus: json['Marital_status'],
      birthDate: DateTime.parse(json['Birth_date']),
      semesterNo: json['Semester_no'],
      section: json['Section'],
      password: json['Password'],
      discipline: json['Discipline'],
    );
  }
}

class Survey {
  String name;
  String createdBy;
  int id;
  int approved;
  String type;
  String status;
  String? aid;
  String dTime;
  String sex;
  String? tech;

  Survey({
    required this.name,
    required this.createdBy,
    required this.id,
    required this.approved,
    required this.type,
    required this.status,
    this.aid,
    required this.dTime,
    required this.sex,
    this.tech,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      name: json['name'],
      createdBy: json['createdby'],
      id: json['id'],
      approved: json['approved'],
      type: json['type'],
      status: json['status'],
      aid: json['aid'],
      dTime: json['dTime'],
      sex: json['sex'],
      tech: json['tech'],
    );
  }
}
