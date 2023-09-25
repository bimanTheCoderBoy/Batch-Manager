import 'package:flutter/material.dart';

import './Question.dart';
import 'dart:convert';

class Quiz {
  String? id;
  String? name;
  List<String>? batches;
  String? time;
  DateTime? switchTime;
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
    if (json['switchTime'] != null) {
      switchTime = DateTime.parse(json['switchTime']);
    }

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
    if (switchTime != null) {
      data['switchTime'] = switchTime!.toIso8601String();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
