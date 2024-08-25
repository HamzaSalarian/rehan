import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChkBox extends StatefulWidget {
  ChkBox({super.key});

  bool isChk = true;
  String txt = "";

  ChkBox.set(isChked, text) {
    isChk = isChked;
    txt = text;
  }
  @override
  State<ChkBox> createState() => _ChkBoxState();
}

class _ChkBoxState extends State<ChkBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.isChk,
          onChanged: (value) {
            setState(() {
              widget.isChk = value!;
            });
          },
        ),
        Text(widget.txt),
      ],
    );
  }
}
