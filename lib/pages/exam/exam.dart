import 'dart:math';

import 'package:batch_manager/pages/exam/addExam.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  var examList = [];
  bool loading = true;
  makingExamList() async {
    examList = await ExamMethods.getExams();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    makingExamList();
    super.initState();
  }

  String name(String n) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: BackButton(color: Colors.black),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              title: Text(
                "Exams",
                style: GoogleFonts.hubballi(fontSize: 25),
              ),
              actions: [
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500.0)),
                  clipBehavior: Clip.hardEdge,
                  color: Color.fromARGB(0, 255, 193, 7),
                  child: IconButton(
                      splashColor: Colors.black26,
                      iconSize: 50,
                      onPressed: () async {
                        await ExamMethods.addExam(context);
                        await makingExamList();
                      },
                      icon: Container(
                          // height: 50,
                          // width: 60,

                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(137, 142, 141, 141),
                                    blurRadius: 1)
                              ],
                              color: Color(0X70FEFDFC),
                              borderRadius: BorderRadius.circular(500)),
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ))),
                ),
              ],
              centerTitle: true,
              elevation: 0,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : examList.length == 0
                      ? Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : ListView.builder(
                          itemCount: examList.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.black87),
                              onPressed: () {},
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 0, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Exam : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                    Text(
                                                      name(
                                                          "${examList[index]["examName"]}"),
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Date : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                    Text(
                                                      "${examList[index]["date"]}",
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                  "${examList[index]["totalMarks"]}"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            // color: Colors.amber,
                                            alignment: Alignment.center,

                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          182, 184, 35, 35),
                                                  elevation: 0,
                                                ),
                                                onPressed: () {},
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                )),
                                          ),
                                          Container(
                                            // color: Colors.amber,
                                            alignment: Alignment.center,
                                            // width: MediaQuery.of(context).size.width -
                                            //     60,

                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          182, 73, 134, 255),
                                                  elevation: 0,
                                                ),
                                                onPressed: () {},
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Send Message",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            )));
  }
}
