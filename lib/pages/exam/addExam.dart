import 'package:background_sms/background_sms.dart';
import 'package:batch_manager/pages/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../util/noti.dart';

class Batch {
  String name = "";
  String id = "";
  bool value = false;
}

class ExamMethods {
  static String name(String n) {
    String nn = "";
    int i = 0;

    while (i < n.length) {
      nn += n[i];
      if (i == 23) {
        nn += "..";
        break;
      }
      i++;
    }

    return nn;
  }

  static createDatabaseExam(
      List<Batch> batches, var examName, var totalMarks) async {
    var user = FirebaseAuth.instance.currentUser;
    List<String> databaseBatches = [];
    for (var e in batches) {
      if (e.value) databaseBatches.add(e.name as String);
    }

    //database operation
    //teacher exam object
    var examInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    var examArray = [];
    try {
      examArray = await examInstance.data()?["examArray"];
    } catch (e) {}
    var newExam = {
      "examName": examName,
      "totalMarks": totalMarks,
      "batches": databaseBatches,
      "date": DateTime.now().toLocal().toString().substring(0, 10),
    };
    examArray = [newExam, ...examArray];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({"examArray": examArray});

    //student exam add----------------------------------------------->
    var studentInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("student")
        .get();

    for (var e in studentInstance.docs) {
      if (databaseBatches.contains(e.data()['batch'])) {
        var studentExamArray = [];
        try {
          studentExamArray = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection("student")
              .doc(e.id)
              .get()
              .then((value) => value.data()?["studentExamArray"]);
        } catch (e) {}
        var newstudentExam = {
          "examName": examName,
          "totalMarks": totalMarks,
          "yourMarks": 0,
          "date": DateTime.now().toLocal().toString().substring(0, 10),
        };
        studentExamArray = [newstudentExam, ...studentExamArray];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection("student")
            .doc(e.id)
            .update({"studentExamArray": studentExamArray});
      }
    }
  }

  static addExam(BuildContext context) {
    List<Batch> batches = [];
    bool call = true;
    var _totalMarks = TextEditingController();
    var _examName = TextEditingController();
    return showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(builder: (context, setStateSB) {
                String name(String n) {
                  String nn = "";
                  int i = 0;

                  while (i < n.length) {
                    nn += n[i];
                    if (i == 15) {
                      nn += "..";
                      break;
                    }
                    i++;
                  }

                  return nn;
                }

                batchLoading() async {
                  var user = FirebaseAuth.instance.currentUser;
                  var batchInstance = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('Batches')
                      .get();
                  batches = await batchInstance.docs.map((e) {
                    Batch t = new Batch();
                    t.id = e.id;
                    t.name = name(e.data()["name"]);
                    t.value = false;
                    return t;
                  }).toList();

                  setStateSB(() {
                    batches;
                  });
                }

                try {
                  if (call) batchLoading();
                  call = false;
                } catch (e) {}
                return Dialog(
                  insetPadding: EdgeInsets.all(10),
                  clipBehavior: Clip.hardEdge,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  insetAnimationCurve: Curves.elasticInOut,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(color: Color(0xffA38762), width: 1.5)),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 34, 115, 255),
                                        width: 3))),
                            child: GradientText(
                              "Create Exam",
                              style: GoogleFonts.hubballi(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                              colors: [
                                Color.fromARGB(255, 240, 160, 50),
                                Color.fromARGB(255, 34, 115, 255)
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(bottom: 20),
                            child: TextField(
                              onSubmitted: (value) => {},
                              textInputAction: TextInputAction.next,
                              controller: _examName,
                              decoration: InputDecoration(
                                  label: Text("Exam Name"),
                                  // hintText: "mobile",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 136, 4, 243),
                                          width: 1.5)),
                                  prefixIcon: Icon(
                                    Icons.book,
                                    color: Color.fromARGB(255, 140, 140, 140),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(bottom: 20),
                            child: TextField(
                              onSubmitted: (value) => {},
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: _totalMarks,
                              decoration: InputDecoration(
                                  label: Text("Total Marks"),
                                  // hintText: "mobile",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 136, 4, 243),
                                          width: 1.5)),
                                  prefixIcon: Icon(
                                    Icons.numbers,
                                    color: Color.fromARGB(255, 140, 140, 140),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            // height: 280,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                182, 73, 134, 255),
                                            width: 2)),
                                    child: batches.length == 0
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ListView.builder(
                                            padding: EdgeInsets.all(0),
                                            itemCount: batches.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 10,
                                                    top: 10),
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.black12,
                                                        width: 2)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '${batches[index].name}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Checkbox(
                                                      value:
                                                          batches[index].value,
                                                      onChanged: (value) {
                                                        setStateSB(() {
                                                          batches[index].value =
                                                              value as bool;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 43,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 255, 255, 255),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 165, 165, 165),
                                            width: 1.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        )),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: GradientText(
                                      "Cancel",
                                      style: GoogleFonts.hubballi(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                      colors: [
                                        Color.fromARGB(255, 240, 160, 50),
                                        Color.fromARGB(255, 34, 115, 255)
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 43,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 255, 255, 255),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 165, 165, 165),
                                            width: 1.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        )),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }));
                                      await createDatabaseExam(
                                          batches,
                                          _examName.text,
                                          int.parse(
                                              (_totalMarks.text.trim() == "")
                                                  ? "0"
                                                  : _totalMarks.text.trim()));
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: GradientText(
                                      "Confirm",
                                      style: GoogleFonts.hubballi(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                      colors: [
                                        Color.fromARGB(255, 240, 160, 50),
                                        Color.fromARGB(255, 34, 115, 255)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
        transitionDuration: Duration(milliseconds: 150),
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Text("page builder");
        });
  }

  static getExams() async {
    var user = FirebaseAuth.instance.currentUser;
    var examInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    var examArray = [];
    try {
      examArray = await examInstance.data()?["examArray"];
    } catch (e) {}
    return examArray;
  }

  static getExamStudent(var exam) async {
    String examName = exam["examName"];
    num totalMarks = exam["totalMarks"];
    var batches = exam["batches"];
    var user = FirebaseAuth.instance.currentUser;
    //------------------------->
    var markDistributionArray = [];

    //getting student instance
    var studentInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("student")
        .get();

    for (var e in studentInstance.docs) {
      if (batches.contains(e.data()['batch'])) {
        //exam Array checking
        var examArray = e.data()['studentExamArray'];
        if (examArray != null) {
          for (var ele in examArray) {
            if (ele["examName"] == examName) {
              var markDistributionObject = {
                "sId": e.id,
                "sName": e.data()['name'],
                "sBatch": e.data()['batch'],
                "sMark": ele['yourMarks']
              };

              markDistributionArray.add(markDistributionObject);
              break;
            }
          }
        }
      }
    }
    return markDistributionArray;
  }

  static studentMarkUpdate(value, sId, examName) async {
    //taking student instance
    var user = FirebaseAuth.instance.currentUser;
    var studentInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('student')
        .doc(sId)
        .get();
    //getting examArray
    var examArray = [];
    examArray = await studentInstance.data()?['studentExamArray'];
    //traversing the array to the exam
    examArray = examArray.map((e) {
      if (e['examName'] == examName) {
        return {
          "examName": e['examName'],
          "totalMarks": e['totalMarks'],
          "date": e["date"],
          "yourMarks": int.parse(value == "" ? "0" : value)
        };
      } else {
        return e;
      }
    }).toList();
//finall update
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('student')
        .doc(sId)
        .update({"studentExamArray": examArray});
  }

//delete
  static deleteExam(exam) async {
    var user = FirebaseAuth.instance.currentUser;

    //database operation

    //student exam add----------------------------------------------->
    var studentInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("student")
        .get();

    for (var e in studentInstance.docs) {
      if (exam['batches'].contains(e.data()['batch'])) {
        var studentExamArray = [];
        try {
          studentExamArray = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection("student")
              .doc(e.id)
              .get()
              .then((value) => value.data()?["studentExamArray"]);
        } catch (e) {
          studentExamArray = [];
        }

        var updatedStudentExamArray = [];
        for (var e in studentExamArray) {
          if (e['examName'] == exam['examName']) continue;
          updatedStudentExamArray.add(e);
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection("student")
            .doc(e.id)
            .update({"studentExamArray": updatedStudentExamArray});
      }
    }
    //teacher exam object
    var teacherInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    var examArray = [];
    try {
      examArray = await teacherInstance.data()?["examArray"];
    } catch (e) {}

    var updatedExamArray = [];
    for (var e in examArray) {
      if (e['examName'] == exam['examName']) {
        continue;
      }
      updatedExamArray.add(e);
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({"examArray": updatedExamArray});
  }

//send Message
  static sendMessage(exam, contactType, simSlot) async {
    var contactMessageArray = [];
    String message =
        ", message from Chemia Galaxy , your Marks for the Exam ${exam['examName']} is";

//student instance
    var user = FirebaseAuth.instance.currentUser;
    var studentInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("student")
        .get();
//traversing all the student
    for (var stu in studentInstance.docs) {
      //batch matching
      if (exam['batches'].contains(stu['batch'])) {
        //Student Exam array
        var studentExamArray = stu['studentExamArray'];

        //traversing student Exam array to find the actual exam object
        for (var aea in studentExamArray) {
          if (exam['examName'] == aea['examName']) {
            var number = 0;
            try {
              number = (contactType == "Student")
                  ? stu['number']
                  : stu['guardianNumber'];
            } catch (e) {}
            if (number != 0) {
              var messageObject = {
                "number": "${number}",
                "message": "Hi ${stu['name']}" +
                    message +
                    " ${aea['yourMarks']} out of ${aea['totalMarks']}"
              };
              contactMessageArray.add(messageObject);
            }
          }
        }
      }
    }

    //sending sms

    int count = 0;
    for (var ele in contactMessageArray) {
      count++;
      Future.delayed(const Duration(milliseconds: 500), () async {
        try {
          await BackgroundSms.sendMessage(
              phoneNumber: ele['number'],
              message: ele['message'],
              simSlot: int.parse(simSlot));
        } catch (e) {
          print(e);
          count--;
          Fluttertoast.showToast(
              msg: "SMS sending Error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Color.fromARGB(255, 247, 109, 109),
              textColor: Color.fromARGB(255, 226, 226, 226),
              fontSize: 16.0);
        }
      });
    }

    if (count > 0) {
      Fluttertoast.showToast(
          msg: "Successfully send ${count} sms",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 0, 158, 50),
          textColor: Color.fromARGB(255, 226, 226, 226),
          fontSize: 16.0);

      //post sending notification part
      MyNotification myNotification = MyNotification();
      //app notification
      await myNotification.initializeNotifications();
      await myNotification.sendNOtifications(
          'Exam SMS Update', "Exam SMS send to ${count} students successfully");

      //database notification array update
      var notificationInstance = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      List notificationArray = [];
      notificationArray = notificationInstance.data()?["notifications"];
      var newNotification = {
        "body": "Exam SMS send to ${count} students successfully",
        "date": DateTime.now().toLocal().toString().substring(0, 10),
        "time": "${DateTime.now().hour}:${DateTime.now().minute}"
      };
      notificationArray = [newNotification, ...notificationArray];
      // notificationArray.add(newNotification);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'notifications': notificationArray});
    }
  }
}
