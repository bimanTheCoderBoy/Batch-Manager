import './Question.dart';
import 'dart:convert';

class Quiz {
  String? id;
  String? name;
  List<String>? batches;
  String? time;
  bool? switchValue = false;
  List<Question> questions = [];
  Quiz();
  // Quiz(
  //     {this.id,
  //     this.name,
  //     this.batches,
  //     this.time,
  //     this.switchValue,
  //     this.questions});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['batches'] != null) {
      batches = [];
      json['batches'].forEach((v) {
        batches!.add(v);
      });
    }
    time = json['time'];
    switchValue = json['switchValue'];
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.batches != null) {
      data['batches'] = this.batches!.map((v) => v).toList();
    }
    data['time'] = this.time;
    data['switchValue'] = this.switchValue;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
