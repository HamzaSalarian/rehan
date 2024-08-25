import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/http/db.dart';

import 'package:survey_monkey/widgets/spacers.dart';
import 'package:survey_monkey/widgets/textfields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userId.text = '2020-Arid-0198';
    password.text = '123';
    //  userId.text = '333';
    //  password.text = '123';
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
              color: ck.x, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.graphic_eq,
                size: 50,
                color: Colors.white,
              ),
              gap20(),
              const Text(
                "BIIT SURVEY MONKEY",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              textField("UserID", userId),
              textField("Password", password),
              gap10(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              gap20(),
              ElevatedButton(
                onPressed: () {
                  Db().login(id: userId.text, password: password.text);
                },
                child: const Text("LOGIN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
