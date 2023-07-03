import 'dart:convert';

class Question {
  String? name;
  Map<String, bool> answers = {};

  // Question({this.name, this.answers});
  Question();

  Question.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['answers'] != null) {
      // json['answers'].forEach((v) {});
      answers = Map.castFrom(jsonDecode(json['answers']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    if (this.answers != null) {
      data['answers'] = jsonEncode(answers);
    }
    return data;
  }
}
