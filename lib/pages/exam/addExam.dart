import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Batch {
  String name = "";
  String id = "";
  bool value = false;
}

class ExamMethods {
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
}
