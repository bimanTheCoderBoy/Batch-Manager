// import 'dart:html';

import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/student.dart';
import '../exam/addExam.dart';

class Remender extends StatefulWidget {
  const Remender({super.key});

  @override
  State<Remender> createState() => _RemenderState();
}

class _RemenderState extends State<Remender> {
  var user = FirebaseAuth.instance.currentUser;
  List<StudentItem> students = [];
  List batches = [];
  List batchesObject = [];
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    var mapppedData = await records.docs.map((e) {
      return StudentItem.fromJson(e);
    }).toList();

    setState(() {
      students = mapppedData;
      print(students);
    });
  }

  fetchRecordStudent() async {
    var studentsFirebaseData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection("student")
        .get();

    await mapRecords(studentsFirebaseData);
  }

  fetchRecordBatch() async {
    var batchesInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection("Batches")
        .get();

    var data = batchesInstance.docs.map((e) {
      return e['name'];
    }).toList();
    setState(() {
      batches = data;
    });
  }

  fetchRecordBatchObject() async {
    var batchesInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection("Batches")
        .get();

    var data = batchesInstance.docs.map((e) {
      return {"name": e['name'], "price": e['price']};
    }).toList();
    setState(() {
      batchesObject = data;
    });
  }

  studentFilter(var batchName) async {
    var batchStudent = students.where((student) {
      return student.batch == batchName;
    }).toList();

    var accountStudent = batchStudent.where((student) {
      var acc = student.account.reversed.toList();

      if (acc.length >= 2) {
        for (var i = 1; i < acc.length; i++) {
          if (acc[i].isPaid) {
          } else {
            return true;
          }
        }
        return false;
      }
      return false;
    }).toList();
    for (var e in accountStudent) {
      String number = (contactNumber == 'Student')
          ? e.number.toString()
          : e.guardianNumber.toString();

      //finding batch price
      int price = 0;
      try {
        for (var element in batchesObject) {
          if (element['name'] == e.batch) {
            price = element['price'];
            break;
          }
        }
      } catch (e) {}

      try {
        await sendMsg(number, e.balance - price, simSlot);
      } catch (e) {}
    }
    Fluttertoast.showToast(
        msg: "SMS sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Color.fromARGB(255, 2, 174, 62),
        textColor: Color.fromARGB(255, 226, 226, 226),
        fontSize: 16.0);
  }

  sendMsg(String number, var balance, var slot) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: number.toString(),
        message:
            "Reminder from CHEMIA GALAXY:\nyou have ${balance} rupees due including the current month please pay your due amount as soon as possible");
  }

  @override
  void initState() {
    super.initState();
    fetchRecordBatch();
    fetchRecordStudent();
    fetchRecordBatchObject();
  }

  var contactNumber = "Student";
  var simSlot = "1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDEC39E),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Reminder",
          style: GoogleFonts.hubballi(fontSize: 25),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
          child: batches.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: batches.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  batches[index],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.zero,
                                      topRight: Radius.circular(7),
                                      bottomRight: Radius.circular(7),
                                      bottomLeft: Radius.zero,
                                    ),
                                  )),
                              onPressed: () {
                                showGeneralDialog(
                                    context: context,
                                    transitionBuilder:
                                        (context, a1, a2, widget) =>
                                            Transform.scale(
                                                scale: a1.value,
                                                child: StatefulBuilder(builder:
                                                    (context, setStateSB) {
                                                  return Dialog(
                                                    insetPadding:
                                                        EdgeInsets.only(
                                                            left: 15,
                                                            right: 15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      // alignment: Alignment.center,
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          20),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Center(
                                                                child: Text(
                                                                  "Select SMS Type",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              // margin:
                                                              //     EdgeInsets.only(right: 20, left: 20),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 25,
                                                                      left: 10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black12,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7)),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Radio(
                                                                        value:
                                                                            "Student",
                                                                        groupValue:
                                                                            contactNumber,
                                                                        onChanged:
                                                                            (value) {
                                                                          setStateSB(
                                                                              () {
                                                                            contactNumber =
                                                                                value.toString();
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                          "Student")
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Radio(
                                                                        value:
                                                                            "Guardian",
                                                                        groupValue:
                                                                            contactNumber,
                                                                        onChanged:
                                                                            (value) {
                                                                          setStateSB(
                                                                              () {
                                                                            contactNumber =
                                                                                value.toString();
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                          'Guardian')
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 25,
                                                                      left: 10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black12,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7)),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Radio(
                                                                        value:
                                                                            "1",
                                                                        groupValue:
                                                                            simSlot,
                                                                        onChanged:
                                                                            (value) {
                                                                          setStateSB(
                                                                              () {
                                                                            simSlot =
                                                                                value.toString();
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                          "Sim Slot 1")
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Radio(
                                                                        value:
                                                                            "2",
                                                                        groupValue:
                                                                            simSlot,
                                                                        onChanged:
                                                                            (value) {
                                                                          setStateSB(
                                                                              () {
                                                                            simSlot =
                                                                                value.toString();
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                          'Sim Slot 2')
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                  height: 43,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.white60,
                                                                        side: BorderSide(color: Color.fromARGB(255, 165, 165, 165), width: 1.5),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7), // <-- Radius
                                                                        )),
                                                                    onPressed:
                                                                        (() {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }),
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black87,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 43,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Color.fromARGB(182, 73, 134, 255),
                                                                        side: BorderSide(color: Color.fromARGB(255, 165, 165, 165), width: 1.5),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7), // <-- Radius
                                                                        )),
                                                                    onPressed:
                                                                        () async {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: ((context) =>
                                                                              Center(
                                                                                child: CircularProgressIndicator(),
                                                                              )));
                                                                      await studentFilter(
                                                                          batches[
                                                                              index]);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "Send",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              221,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ]),
                                                    ),
                                                  );
                                                })),
                                    transitionDuration:
                                        Duration(milliseconds: 150),
                                    barrierLabel: '',
                                    pageBuilder:
                                        (context, animation1, animation2) {
                                      return Text("page builder");
                                    });
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(7),
                                        bottomRight: Radius.circular(7))),
                                child: Icon(
                                  Icons.send,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]),
                    );
                  },
                )),
    );
  }
}
