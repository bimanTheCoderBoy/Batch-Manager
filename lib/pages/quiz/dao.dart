import 'package:batch_manager/pages/quiz/Quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

addquiz(Quiz quiz) async {
  //getting user instance
  var user = FirebaseAuth.instance.currentUser;

  var quizArray = [];
  //getting quiz array instance
  var databaseQuizInstance =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  //getting quiz array
  var databaseQuizArray =
      await databaseQuizInstance.data()!['teacherQuizArray'];

  if (databaseQuizArray != null) {
    quizArray = [...databaseQuizArray];
  }
  quizArray = quizArray.where((e) {
    return e['id'] != quiz.id;
  }).toList();
  //prepearing the updated array
  quizArray = [quiz.toJson(), ...quizArray];

  //update on database
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update({"teacherQuizArray": quizArray});
}

readQuizes() async {
  //getting user instance
  var user = FirebaseAuth.instance.currentUser;

  List<Quiz> quizArray = [];
  //getting quiz array instance
  var databaseQuizInstance =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  //getting quiz array
  var databaseQuizArray =
      await databaseQuizInstance.data()!['teacherQuizArray'];
  if (databaseQuizArray != null) {
    for (var e in databaseQuizArray) {
      quizArray.add(Quiz.fromJson(e));
    }
  }
  return quizArray;
}

deleteQuiz(Quiz quiz) async {
  //getting user instance
  var user = FirebaseAuth.instance.currentUser;

  var quizArray = [];
  //getting quiz array instance
  var databaseQuizInstance =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  //getting quiz array
  var databaseQuizArray =
      await databaseQuizInstance.data()!['teacherQuizArray'];

  if (databaseQuizArray != null) {
    quizArray = [...databaseQuizArray];
  }
  quizArray = quizArray.where((e) {
    return e['id'] != quiz.id;
  }).toList();

  //update on database
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update({"teacherQuizArray": quizArray});
}
