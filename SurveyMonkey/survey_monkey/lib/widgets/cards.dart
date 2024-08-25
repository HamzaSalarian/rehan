import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_monkey/constants.dart';

previousCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(10),
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ck.x,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Survey 1"),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Conduct"),
        ),
        // IconButton(onPressed: (){Get.to(()=>const BarChart(id: null,));}, icon: const Icon(Icons.remove_red_eye_outlined)),
        // IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
      ],
    ),
  );
}

activeCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(10),
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ck.x,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Survey 1"),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Respond"),
        ),
      ],
    ),
  );
}

pendingCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(10),
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ck.x,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Survey 1"),
        IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      ],
    ),
  );
}

approvalCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(10),
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ck.x,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Survey 1"),
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                )),
          ],
        )
      ],
    ),
  );
}
