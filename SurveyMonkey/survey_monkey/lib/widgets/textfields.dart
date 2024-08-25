import 'package:flutter/material.dart';

textField(name,controller){
  var obs=false;
  if(name=="Password"){
    obs=true;
  }
  return TextField(
    controller: controller,
    obscureText: obs,
    decoration: InputDecoration(hintText: name),
  );
}