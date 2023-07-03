import 'dart:math';

import 'package:batch_manager/main.dart';
import 'package:batch_manager/util/monthlyFee.dart';
import 'package:batch_manager/util/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:telephony/telephony.dart';
import 'package:background_sms/background_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

class StudentOpen extends StatefulWidget {
  late var id;
  late var name;
  late var number;
  late var balance;
  late var batch;
  late var guardianNumber = null;
  late List<MonthlyFee> account = [];

  StudentOpen(
      {super.key,
      required this.id,
      required this.name,
      required this.account,
      required this.balance,
      required this.batch,
      required this.number,
      required this.guardianNumber});

  @override
  State<StudentOpen> createState() => _StudentOpenState();
}

class _StudentOpenState extends State<StudentOpen> {
  // StudentItem? itemS;
  var _message = TextEditingController();
  var user;

  FocusNode smsFocus = FocusNode();
  // final Telephony telephony = Telephony.instance;
  bool smsArea = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    dropDownBatchdata();
    getPermission();
    _guardianNumber.text =
        (widget.guardianNumber == null) ? "0" : "${widget.guardianNumber}";
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

  var _studentName = TextEditingController();
  var _studentNumber = TextEditingController();
  var _guardianNumber = TextEditingController();
  //getting list of batches
  List batches = [];
  late String dropdownvalue;
  dropDownBatchdata() async {
    CollectionReference dropDown = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("Batches");
    var allData = await dropDown.get();
    var data = allData.docs.map((e) {
      return e['name'];
    }).toList();
    batches = [...data];
    dropdownvalue = batches[0];
  }

  //update data
  updateStudent(var batch) {
    List<Object> account1 = [];
    for (int i = 0; i < widget.account.length; i++) {
      account1.add(widget.account[i].toJson());
    }
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('student')
          .doc(widget.id)
          .update({
        "name": _studentName.text,
        "number": int.parse(_studentNumber.text),
        "batch": dropdownvalue,
        "balance": widget.balance,
        "guardianNumber": int.parse(_guardianNumber.text),
        "account": account1
      });
      setState(() {
        widget.name = _studentName.text;
        widget.number = int.parse(_studentNumber.text);
        widget.batch = dropdownvalue;
        widget.guardianNumber = int.parse(_guardianNumber.text);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Somthing went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Color.fromARGB(215, 247, 247, 247),
          textColor: Color.fromARGB(255, 221, 82, 82),
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  String contactNumber = "Student";
  @override
  Widget build(BuildContext context) {
    var batch = widget.batch;
    var stuid = widget.id;

    openAddStudentDialogue() => showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(
                  builder: (context, setStateSB) => Dialog(
                        insetPadding: EdgeInsets.all(25),
                        clipBehavior: Clip.hardEdge,
                        insetAnimationDuration: Duration(milliseconds: 100),
                        insetAnimationCurve: Curves.elasticInOut,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    color: Color(0xffA38762), width: 1.5)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 136, 4, 243),
                                              width: 3))),
                                  child: GradientText(
                                    "Update Student",
                                    style: GoogleFonts.hubballi(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
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
                                    controller: _studentName,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        label: Text("name"),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 136, 4, 243),
                                                width: 1.5)),
                                        prefixIcon: Icon(
                                          Icons.person_add,
                                          color: Color.fromARGB(
                                              255, 140, 140, 140),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: TextField(
                                    onSubmitted: (value) => {},
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    controller: _studentNumber,
                                    decoration: InputDecoration(
                                        label: Text("phone"),
                                        // hintText: "mobile",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 136, 4, 243),
                                                width: 1.5)),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Color.fromARGB(
                                              255, 140, 140, 140),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: TextField(
                                    onSubmitted: (value) => {},
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    controller: _guardianNumber,
                                    decoration: InputDecoration(
                                        label: Text("guardian phone"),
                                        // hintText: "mobile",
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 136, 4, 243),
                                                width: 1.5)),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Color.fromARGB(
                                              255, 140, 140, 140),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: DropdownButtonFormField(
                                    // Initial Value

                                    isExpanded: true,
                                    value: dropdownvalue,
                                    disabledHint: Text("Batch"),
                                    // Down Arrow Icon
                                    // icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: batches.map((dynamic items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (dynamic newValue) {
                                      setStateSB(() {
                                        dropdownvalue = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        label: Text("batch"),
                                        prefixIcon: Icon(Icons.people,
                                            color: Color.fromARGB(
                                                255, 140, 140, 140)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 136, 4, 243),
                                                width: 1.5)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 43,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 165, 165, 165),
                                                  width: 1.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12), // <-- Radius
                                              )),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            dropdownvalue = batches[0];
                                            _studentName.clear();

                                            _studentNumber.clear();
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
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 165, 165, 165),
                                                  width: 1.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12), // <-- Radius
                                              )),
                                          onPressed: () {
                                            updateStudent(stuid);
                                            Navigator.pop(context);
                                            dropdownvalue = batches[0];
                                            _studentName.clear();

                                            _studentNumber.clear();
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
                      )),
            ),
        transitionDuration: Duration(milliseconds: 150),
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Text("page builder");
        });
    head() {
      String name(n) {
        String nn = "";
        int i = 0;

        while (i < n.length) {
          nn += n[i];
          if (i == 18) {
            nn += "..";
            break;
          }
          i++;
        }

        return nn;
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Color.fromARGB(0, 255, 193, 7),
                child: IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: Icon(Icons.arrow_back)),
              ),
              Text(
                name(widget.name),
                style: GoogleFonts.hubballi(fontSize: 25),
              ),
              Material(
                color: Color.fromARGB(0, 255, 193, 7),
                child: IconButton(
                    onPressed: () {
                      _studentName.text = widget.name;
                      _studentNumber.text = widget.number.toString();
                      dropdownvalue = widget.batch;
                      openAddStudentDialogue();
                    },
                    icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(0, 142, 141, 141),
                                  blurRadius: 1)
                            ],
                            color: Color.fromARGB(0, 254, 253, 252),
                            borderRadius: BorderRadius.circular(500)),
                        child: Icon(Icons.edit))),
              ),
            ],
          ),
        ),
      );
    }

    ;

    down() {
      String name(n) {
        String nn = "";
        int i = 0;

        while (i < n.length) {
          nn += n[i];
          if (i == 9) {
            nn += "..";
            break;
          }
          i++;
        }

        return nn;
      }

      _sendSMS() async {
        // final Telephony telephony = Telephony.instance;
        // if (await telephony.requestPhoneAndSmsPermissions ?? false) {
        //   await telephony.sendSmsByDefaultApp(
        //     to: widget.number.toString(),
        //     message: _message.text,
        //   );
        // }
        String numberSms = (contactNumber == "Student")
            ? widget.number.toString()
            : widget.guardianNumber.toString();
        if (widget.guardianNumber == null) numberSms = widget.number.toString();
        var result = await BackgroundSms.sendMessage(
            phoneNumber: numberSms.toString(), message: _message.text);
        if (result == SmsStatus.sent) {
          Fluttertoast.showToast(
              msg: "message sent",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Color.fromARGB(255, 209, 209, 209),
              textColor: Color.fromARGB(255, 120, 120, 120),
              fontSize: 14.0);
          print("Sent");
        } else {
          Fluttertoast.showToast(
              msg: "message has not sent",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Color.fromARGB(255, 207, 206, 206),
              textColor: Color.fromARGB(255, 142, 142, 142),
              fontSize: 14.0);
          print("Failed");
        }
        setState(() {
          smsArea = false;
        });
      }

      sendSMS() async {
        await _sendSMS();
      }

      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            padding: EdgeInsets.only(right: 40, left: 10),
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(7)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio(
                      value: "Student",
                      groupValue: contactNumber,
                      onChanged: (value) {
                        setState(() {
                          contactNumber = value.toString();
                        });
                      },
                    ),
                    Text("Student")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: "Guardian",
                      groupValue: contactNumber,
                      onChanged: (value) {
                        setState(() {
                          contactNumber = value.toString();
                        });
                      },
                    ),
                    Text('Guardian')
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 20, left: 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        focusNode: smsFocus,
                        controller: _message,
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (value) {
                          setState(() {
                            if (value == "") {
                              smsArea = false;
                            } else {
                              smsArea = true;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: " type a message",
                          contentPadding: EdgeInsets.only(
                              left: 15, right: 10, top: 5, bottom: 5),
                          border: InputBorder.none,
                        ),
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 5),
                alignment: Alignment.centerRight,
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Color.fromARGB(0, 255, 193, 7),
                  child: IconButton(
                      splashColor: Color.fromARGB(80, 0, 0, 0),
                      alignment: Alignment.center,
                      iconSize: 50,
                      onPressed: () {
                        if (!smsArea)
                          FlutterPhoneDirectCaller.callNumber(
                              (contactNumber == "Student")
                                  ? widget.number.toString()
                                  : (widget.guardianNumber == null)
                                      ? widget.number.toString()
                                      : widget.guardianNumber.toString());
                        else {
                          sendSMS();
                          _message.clear();
                          smsFocus.unfocus();
                        }
                      },
                      icon: InkWell(
                        splashColor: Color.fromARGB(80, 0, 0, 0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(95, 70, 70, 70),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0))
                              ],
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(300)),
                          child: Icon(
                            (!smsArea) ? Icons.call : Icons.send,
                            size: 28,
                          ),
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      );
    }

    sendConfermation(monthYear) async {
      var result = await BackgroundSms.sendMessage(
          phoneNumber: widget.number.toString(),
          message:
              "you have successfully paid your Chemia Galaxy tuition fees for ${monthYear}");
    }

    updateMonthlyEarning(amount) async {
      user = FirebaseAuth.instance.currentUser;
      var userInstance = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      List userEarning = await userInstance.data()?['monthlyEarningArray'];
      if (userEarning.isNotEmpty) {
        userEarning[0]['me'] = userEarning[0]['me'] + amount as int;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({"monthlyEarningArray": userEarning});
      }
    }

    fees() {
      List<MonthlyFee> account = widget.account;
      return ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: account.length,
          itemBuilder: ((context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10, left: 25, right: 25),
              padding: EdgeInsets.only(left: 25, right: 15),
              height: 80,
              decoration: BoxDecoration(
                  color: Color.fromARGB(47, 6, 6, 6),
                  border: Border.all(color: Color(0xffA38762), width: 1),
                  borderRadius: BorderRadius.circular(11)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account[index].month,
                        style: GoogleFonts.actor(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Text(
                        account[index].year,
                        style: GoogleFonts.actor(
                            fontSize: 15, color: Colors.black54),
                      ),
                    ],
                  ),
                  if (!account[index].isPaid)
                    Material(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Color.fromARGB(0, 255, 193, 7),
                      child: IconButton(
                          splashColor: Colors.black45,
                          iconSize: 30,
                          onPressed: () async {
                            await sendConfermation("${account[index].month}"
                                " ${account[index].year}");
                            await updateMonthlyEarning(account[index].dueMoney);
                            setState(() {
                              account[index].isPaid = true;
                              account[index].paidDate = DateTime.now()
                                  .toLocal()
                                  .toString()
                                  .substring(0, 10);

                              List<Object> account1 = [];
                              for (int i = 0; i < account.length; i++) {
                                account1.add(account[i].toJson());
                              }
                              widget.balance =
                                  widget.balance - account[index].dueMoney;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('student')
                                  .doc(widget.id)
                                  .update({
                                "name": widget.name,
                                "number": widget.number,
                                "batch": widget.batch,
                                "balance": widget.balance,
                                "account": account1
                              });
                            });
                          },
                          icon: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(53, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(500),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 255, 172, 7),
                                      width: 1)),
                              child: Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 160, 1, 1),
                                size: 25,
                              ))),
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paid",
                          style: GoogleFonts.actor(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 134, 36)),
                        ),
                        Text(
                          account[index].paidDate,
                          style: GoogleFonts.actor(
                              fontSize: 15, color: Colors.black54),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }));
    }

    body() {
      String name(n) {
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

      return Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        decoration: const BoxDecoration(
            boxShadow: [
              // BoxShadow(color: Colors.black38, blurRadius: 2, offset: Offset(0, 0))
            ],
            color: Color.fromARGB(101, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  // scrollDirection: Axis.horizontal,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Batch:",
                          style: GoogleFonts.hubballi(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(125, 0, 0, 0)),
                        ),
                        Text(
                          name(widget.batch),
                          style: GoogleFonts.hubballi(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(110, 0, 0, 0)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Total Due:",
                          style: GoogleFonts.hubballi(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(125, 0, 0, 0)),
                        ),
                        Text(
                          " ₹ " + name(widget.balance.toString()),
                          style: GoogleFonts.hubballi(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(110, 0, 0, 0)),
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                  child: GradientText(
                "Transections",
                style: GoogleFonts.hubballi(
                    fontSize: 30, fontWeight: FontWeight.w900),
                colors: [
                  Color.fromARGB(168, 4, 0, 64),
                  Color.fromARGB(255, 123, 122, 122),
                ],
              )),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(25, 0, 0, 0)),
                  child: Container(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: fees()),
                )),
            down()
          ],
        ),
      );
    }

    return Scaffold(
      body: Material(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
            child: Column(
              children: [head(), Expanded(flex: 1, child: body())],
            )),
      ),
    );
  }
}
