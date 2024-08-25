class Answers {
  late int qid;
  late String response;
  late bool isSkipped; // New field to indicate if the question was skipped

  Answers({required this.qid, required this.response, this.isSkipped = false});
}
