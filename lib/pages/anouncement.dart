import 'package:background_sms/background_sms.dart';
import 'package:batch_manager/util/noti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../util/student.dart';

class Batch {
  String name = "";
  String id = "";
  bool value = false;
}

class Anouncement extends StatefulWidget {
  const Anouncement({super.key});

  @override
  State<Anouncement> createState() => _AnouncementState();
}

class _AnouncementState extends State<Anouncement> {
  List<Batch> batches = [];
  var user = FirebaseAuth.instance.currentUser;
  var _massage = TextEditingController();
  List<StudentItem> students = [];
  late TwilioFlutter twilioFlutter;
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    var mapppedData = await records.docs.map((e) {
      return StudentItem.fromJson(e);
    }).toList();
    setState(() {
      students = mapppedData;
    });
  }

  studentLoading() async {
    var studentsFirebaseData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("student")
        .get();
    mapRecords(studentsFirebaseData);
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
    setState(() {
      batches;
    });
  }

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

  // apiTesting() async {
  //   twilioFlutter = TwilioFlutter(
  //       accountSid: 'ACb643755f8f6c2cabc78898b73bddcbcb',
  //       authToken: 'f76c1f5692477744eafb393b880fb8dd',
  //       twilioNumber: '+12705143722');
  // }

  send(String massage) async {
    int count = 0;
    bool selectedOrNot = false;
    var user = FirebaseAuth.instance.currentUser;
    for (var e in batches) {
      if (count > 90) {
        Fluttertoast.showToast(
            msg: "Students greater than 90 not allowed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Color.fromARGB(255, 247, 109, 109),
            textColor: Color.fromARGB(255, 226, 226, 226),
            fontSize: 16.0);
        break;
      }
      if (e.value == true) {
        selectedOrNot = true;
        for (var stu in students) {
          var stuOrGuar =
              (smsTypeValue == null) ? "Student" : smsTypeValue as String;
          if (stuOrGuar == "Guardian" &&
              (stu.guardianNumber == null || stu.guardianNumber == 0))
            stuOrGuar = "Student";
          if (count > 90) {
            break;
          }
          if (stu.batch == e.name) {
            count++;
            Future.delayed(const Duration(milliseconds: 500), () async {
              try {
                // twilioFlutter.sendSMS(
                //     toNumber: "+91${stu.number}", messageBody: massage);
                await BackgroundSms.sendMessage(
                    phoneNumber: (stuOrGuar == "Student")
                        ? stu.number.toString()
                        : stu.guardianNumber.toString(),
                    message: massage,
                    simSlot: int.parse(
                        (simSlotValue == null) ? "1" : simSlotValue as String));
              } catch (e) {
                print(e);

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
        }

        setState(() {
          e.value = false;
        });
      }
    }
    MyNotification myNotification = MyNotification();
    await myNotification.initializeNotifications();
    await myNotification.sendNOtifications(
        'SMS Update', "SMS send to ${count} students successfuly");

    var notificationInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    List notificationArray = [];
    notificationArray = notificationInstance.data()?["notifications"];
    var newNotification = {
      "body": "SMS send to ${count} students successfuly",
      "date": DateTime.now().toLocal().toString().substring(0, 10),
      "time": "${DateTime.now().hour}:${DateTime.now().minute}"
    };
    notificationArray = [newNotification, ...notificationArray];
    // notificationArray.add(newNotification);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'notifications': notificationArray});
    if (selectedOrNot) {
      Fluttertoast.showToast(
          msg: "Massage send successfuly",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(215, 247, 247, 247),
          textColor: Color.fromARGB(255, 0, 158, 50),
          fontSize: 16.0);
      _massage.clear();
    } else
      Fluttertoast.showToast(
          msg: "Please select at least one batch",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 247, 109, 109),
          textColor: Color.fromARGB(255, 226, 226, 226),
          fontSize: 16.0);
  }

  @override
  void initState() {
    // TODO: implement initState
    // apiTesting();
    studentLoading();
    batchLoading();
    getPermission();
    super.initState();
  }

  getPermission() async {
    var status1 = await Permission.sms.status;
    var status2 = await Permission.phone.status;
    if (status1.isDenied) {
      await Permission.sms.request();
    }
    if (status2.isDenied) {
      await Permission.phone.request();
    }
  }

  //dropdown values
  String? smsTypeValue;
  String? simSlotValue;

  @override
  Widget build(BuildContext context) {
    const smsType = ["Student", "Guardian"];
    const simSlot = ["1", "2"];
    guardianAndSlotDropDown() {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        margin: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
        decoration: BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        'Sms Type',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: smsType
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(194, 255, 255, 255),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: smsTypeValue,
                onChanged: (value) {
                  setState(() {
                    smsTypeValue = value as String;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 10,
                iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                iconDisabledColor: Colors.grey,
                buttonHeight: 40,
                buttonWidth: 110,
                buttonPadding: const EdgeInsets.only(left: 10, right: 10),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: Color.fromARGB(255, 233, 195, 129), width: 2),
                  color: Color.fromARGB(14, 30, 30, 30),
                ),
                buttonElevation: 1,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 110,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color.fromARGB(200, 89, 89, 89),
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(0, 0),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        'Sim Slot',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: simSlot
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(194, 255, 255, 255),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: simSlotValue,
                onChanged: (value) {
                  setState(() {
                    simSlotValue = value as String;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 10,
                iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                iconDisabledColor: Colors.grey,
                buttonHeight: 40,
                buttonWidth: 110,
                buttonPadding: const EdgeInsets.only(left: 10, right: 10),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: Color.fromARGB(255, 233, 195, 129), width: 2),
                  color: Color.fromARGB(14, 30, 30, 30),
                ),
                buttonElevation: 1,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 110,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color.fromARGB(200, 89, 89, 89),
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(0, 0),
              ),
            ),
          ],
        ),
      );
    }

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
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              title: Text(
                "Anouncement",
                style: GoogleFonts.hubballi(fontSize: 25),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                          guardianAndSlotDropDown(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color.fromARGB(182, 73, 134, 255),
                                      width: 2)),
                              child: batches.length == 0
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
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
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.black12,
                                                  width: 2)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                '${batches[index].name}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Checkbox(
                                                value: batches[index].value,
                                                onChanged: (value) {
                                                  setState(() {
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
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: []),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _massage,
                            minLines: 10,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(14, 0, 0, 0),
                                label: const Text(
                                  "Type a massage",
                                  style: TextStyle(
                                      color: Color.fromARGB(96, 0, 0, 0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(182, 73, 134, 255),
                                        width: 2)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(182, 46, 53, 248),
                                        width: 2)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              child: Text(
                                "Send massege",
                                style: TextStyle(fontSize: 17),
                              ),
                              onPressed: () async {
                                await send(_massage.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
