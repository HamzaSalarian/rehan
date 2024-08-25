import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';
import 'package:survey_monkey/screens/login.dart';

AppBar appBar() {
  return AppBar(
    backgroundColor: ck.x,
    title: const Text("BIIT Survey Monkey",style: TextStyle(color: Colors.white),),
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {
          Get.offAll(() => const Login());
        },
        icon:const Icon(
          Icons.logout,
          color: Colors.black,
        ),
      ),
    ],
  );
}

AppBar simpleAppBar(){
  return AppBar(
    backgroundColor: ck.x,
    iconTheme: IconThemeData(
        color: Colors.white
    ),
    title: const Text("BIIT Survey Monkey",style: TextStyle(color: Colors.white),),
    centerTitle: true,
  );
}
