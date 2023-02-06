// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:batch_manager/pages/batches_page.dart';
import 'package:batch_manager/pages/student_open.dart';
import 'package:batch_manager/util/monthlyFee.dart';
import 'package:batch_manager/util/route.dart';
import 'package:batch_manager/util/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Student extends StatefulWidget {
  String batch = "";
  int batchCount = 0;
  late bool dueList;
  Student({super.key, batch = "Student Dashboard", required this.dueList}) {
    this.batch = batch;
  }

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  FocusNode searchFocus = FocusNode();
  Map<String, int> batchPrice = {};
  bool isFocused = false;
  var _studentSearch = TextEditingController();
  List<StudentItem> studentItemsRun = [];
  var user;
  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance.currentUser;
    loadStudent();
    fetchRecord();
    filterBatch();
    // print(
    //     "                                             ${studentItem[0].name}                             ");
    super.initState();
  }

  deleteStudent(var id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("student")
        .doc(id)
        .delete();
  }

  List<StudentItem> studentItems = [];
  Map<dynamic, bool> selectedItems = {};
  Map<String, int> stuMonth = {};
  List<int> itemsMonth = [0, 1, 2, 3, 4, 5, 6];
  bool loading = true;

  // var batch=widget.batch;
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    await dropDownBatchdata();
    var mapppedData = await records.docs.map((e) {
      int? bprice = batchPrice[e.data()['batch']] ?? 0;
      bprice = bprice == 0 ? bprice = 100000000 : bprice;
      double vv = (e.data()['balance'] / bprice);
      // int v = vv.toInt();

      stuMonth[e.data()['name']] = vv.toInt();
      return StudentItem.fromJson(e);
    }).toList();
    // for (var i = 0; i < studentItemsRun.length; i++) {
    //   print(mapppedData[i].name +
    //       "                           month   ${stuMonth[mapppedData[i].name]}");
    // }
    if (widget.batch != "Student Dashboard") {
      List<StudentItem> batchMap = [];
      for (var e in mapppedData) {
        if (e.batch == widget.batch) {
          batchMap.add(e);
        }
      }
      setState(() {
        mapppedData = batchMap;
      });
    }

    setState(() {
      studentItems = mapppedData;
      List<StudentItem> items = [];

      for (var element in studentItems) {
        selectedItems.addEntries({element.id: false}.entries);
        items.add(element);
      }
      studentItemsRun = items;

      loading = false;
    });
  }

  fetchRecord() async {
    var studentsFirebaseData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("student")
        .get();

    await mapRecords(studentsFirebaseData);
    if (widget.dueList && selectedValueMonth != null)
      dueFilter(int.parse(selectedValueMonth!));
  }

  CollectionReference? student;
  loadStudent() {
    student = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("student");
  }

  var _studentName = TextEditingController();
  var _studentNumber = TextEditingController();
  bool selectedArea = false;
  List<String> batches = [];

  //getting list of batches
  late String dropdownvalue;
  dropDownBatchdata() async {
    CollectionReference dropDown = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("Batches");
    var allData = await dropDown.get();
    var data = allData.docs.map((e) {
      widget.batchCount += 1;
      batchPrice[e['name']] = e['price'];
      return e['name'];
    }).toList();
    if (widget.batchCount > 0) {
      batches = [...data];
      dropdownvalue = batches[0];
    }
  }

  dueFilter(int n) {
    List<StudentItem> temp = [];
    for (var ele in studentItemsRun) {
      if (stuMonth[ele.name]! >= n && n == 6) {
        temp.add(ele);
      } else if (stuMonth[ele.name] == n) {
        temp.add(ele);
      }
    }
    setState(() {
      studentItemsRun = temp;
    });
  }

  addStudent() {
    List<Object> mm = [];

    // mm.add({"year": "biman"});
    student!.add({
      "name": _studentName.text,
      "number":
          int.parse(_studentNumber.text == "" ? "0" : _studentNumber.text),
      "batch":
          (widget.batch == "Student Dashboard") ? dropdownvalue : widget.batch,
      "account": mm,
      "balance": 0,
    });
    setState(() {
      fetchRecord();
    });
  }

  // List of items in our dropdown menu

  List<String> items = [];
  filterBatch() async {
    items.add("All");
    await dropDownBatchdata();
    items.addAll(batches);
  }

  String? selectedValue;
  String? selectedValueMonth;

  @override
  Widget build(BuildContext context) {
    String batch = widget.batch;

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
                                    "Add Student",
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
                                if (batch == "Student Dashboard")
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                            addStudent();
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
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selectedArea)
              Material(
                color: Color.fromARGB(0, 255, 193, 7),
                child: IconButton(
                    onPressed: (() {
                      setState(() {
                        for (int i = 0; i < studentItemsRun.length; i++) {
                          selectedItems[studentItems[i].id] = false;
                        }
                        selectedArea = false;
                      });
                    }),
                    icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(500)),
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                        ))),
              )
            else
              Material(
                color: Color.fromARGB(0, 255, 193, 7),
                child: IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: Icon(Icons.arrow_back)),
              ),
            Text(
              widget.batch,
              style: GoogleFonts.hubballi(fontSize: 25),
            ),
            if (selectedArea)
              Material(
                color: Color.fromARGB(0, 255, 193, 7),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              // alignment: Alignment.center,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Are you sure, you want to delete ?",
                                        style: GoogleFonts.hubballi(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: 43,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    203, 145, 2, 2),
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 32, 32, 32),
                                                    width: 1.5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                )),
                                            onPressed: () {
                                              setState(() {
                                                for (var e in studentItemsRun) {
                                                  if (selectedItems[e.id] ==
                                                      true) {
                                                    selectedItems[e.id] = false;
                                                    deleteStudent(e.id);
                                                  }
                                                }

                                                fetchRecord();
                                                selectedArea = false;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Yes",
                                              style: GoogleFonts.hubballi(
                                                  color: Color.fromARGB(
                                                      221, 255, 255, 255),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
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
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.hubballi(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          );
                        },
                      );
                    },
                    icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(137, 142, 141, 141),
                                  blurRadius: 1)
                            ],
                            color: Color.fromARGB(111, 255, 24, 24),
                            borderRadius: BorderRadius.circular(500)),
                        child: Icon(Icons.delete))),
              )
            else
              Material(
                color: Color.fromARGB(0, 255, 193, 7),
                child: IconButton(
                    onPressed: () async {
                      if (widget.batchCount == 0) {
                        await Navigator.pushNamed(context, Routte.batches);
                        // await Navigator.push(context,(context){})
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BatchList()));

                        setState(() {
                          fetchRecord();
                        });
                      } else
                        openAddStudentDialogue();
                    },
                    icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(137, 142, 141, 141),
                                  blurRadius: 1)
                            ],
                            color: Color(0X70FEFDFC),
                            borderRadius: BorderRadius.circular(500)),
                        child: Icon(Icons.add))),
              ),
          ],
        ),
      );
    }

    studentList() {
      String name(index) {
        String n = studentItemsRun[index].name;
        String nn = "";
        int i = 0;

        while (i < n.length && n[i] != ' ') {
          nn += n[i];
          if (i == 6) {
            nn += "..";
            break;
          }
          i++;
        }

        return nn;
      }

      String safeString(String s) {
        String nn = "";
        int i = 0;

        while (i < s.length && s[i] != ' ') {
          nn += s[i];
          if (i == 8) {
            nn += "..";
            break;
          }
          i++;
        }

        return nn;
      }

      return Expanded(
        flex: 1,
        child: Column(children: [
          if (widget.dueList)
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          // Icon(
                          //   Icons.list,
                          //   size: 14,
                          //   color: Color.fromARGB(255, 255, 255, 255),
                          // ),
                          // SizedBox(
                          //   width: 1,
                          // ),
                          Center(
                            child: Text(
                              'Select Batch',
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
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  safeString(item),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(194, 255, 255, 255),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          widget.batch = value as String;
                          selectedValue = value as String;
                          if (widget.batch == "All")
                            widget.batch = "Student Dashboard";
                          fetchRecord();
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
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Color.fromARGB(255, 233, 195, 129),
                            width: 2),
                        color: Color.fromARGB(14, 30, 30, 30),
                      ),
                      buttonElevation: 1,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 150,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color.fromARGB(200, 89, 89, 89),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(0, -2),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 1,
                          ),
                          Center(
                            child: Text(
                              'Select Month',
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
                      items: itemsMonth
                          .map((item) => DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(
                                  item == 6 ? "> $item month" : "$item month",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(194, 255, 255, 255),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValueMonth,
                      onChanged: (value) {
                        setState(() {
                          selectedValueMonth = value!;
                          fetchRecord();
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
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Color.fromARGB(255, 233, 195, 129),
                            width: 2),
                        color: Color.fromARGB(14, 30, 30, 30),
                      ),
                      buttonElevation: 1,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 150,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color.fromARGB(200, 89, 89, 89),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 2,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-40, -2),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 1,
            child: Container(
              height: 500,
              padding: EdgeInsets.only(
                top: 18,
                bottom: 0,
              ),
              child: loading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : studentItemsRun.length == 0
                      ? Text(
                          "No results found",
                          style: GoogleFonts.hubballi(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: studentItemsRun.length,
                          itemBuilder: (context, index) {
                            return Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: [
                                  Material(
                                    color: Color.fromARGB(0, 255, 193, 7),
                                    child: InkWell(
                                      splashColor: Color.fromARGB(119, 0, 0, 0),
                                      radius: 200,
                                      onTap: () async {
                                        if (selectedArea) {
                                          setState(() {
                                            selectedItems[studentItemsRun[index]
                                                .id] = true;
                                          });
                                        } else {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentOpen(
                                                      id: studentItemsRun[index]
                                                          .id,
                                                      name:
                                                          studentItemsRun[index]
                                                              .name,
                                                      balance:
                                                          studentItemsRun[index]
                                                              .balance,
                                                      account:
                                                          studentItemsRun[index]
                                                              .account,
                                                      batch:
                                                          studentItemsRun[index]
                                                              .batch,
                                                      number:
                                                          studentItemsRun[index]
                                                              .number,
                                                    )),
                                          );
                                          setState(() {
                                            fetchRecord();
                                          });
                                        }
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          selectedItems[
                                              studentItemsRun[index].id] = true;
                                          selectedArea = true;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 0,
                                            bottom: 10,
                                            left: 10,
                                            right: 10),
                                        height: 56,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                37, 217, 217, 217),
                                            border: Border.all(
                                                color: Color(0xffA38762),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(11)),
                                        child: Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              Positioned(
                                                left: -20,
                                                child: Container(
                                                  width: 130,
                                                  height: 37,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffd9d9d9),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(11),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          11))),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        name(index),
                                                        style: GoogleFonts
                                                            .hubballi(
                                                                fontSize: 25),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        studentItemsRun[index]
                                                            .batch,
                                                        style: GoogleFonts
                                                            .hubballi(
                                                                fontSize: 25),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "₹ ${studentItemsRun[index].balance.toString()}",
                                                        style: GoogleFonts
                                                            .hubballi(
                                                                fontSize: 25),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  if (selectedItems[
                                          studentItemsRun[index].id] ==
                                      true)
                                    Positioned(
                                      top: -11,
                                      left: -1,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedItems[studentItemsRun[index]
                                                .id] = false;
                                            int trueCount = 0;
                                            for (var element
                                                in studentItemsRun) {
                                              if (selectedItems[element.id] ==
                                                  true) {
                                                trueCount++;
                                              }
                                            }
                                            if (trueCount == 0) {
                                              selectedArea = false;
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(11),
                                          height: 56,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  180, 37, 37, 37),
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 252, 183, 34),
                                                  width: 2)),
                                        ),
                                      ),
                                    )
                                ]);
                          },
                        ),
            ),
          ),
        ]),
      );
    }

    void runFilter() {
      List<StudentItem> filteredData = [];

      for (var i = 0; i < studentItems.length; i++) {
        if (studentItems[i]
            .name
            .toLowerCase()
            .contains(_studentSearch.text.toLowerCase())) {
          filteredData.add(studentItems[i]);
        }
      }
      setState(() {
        studentItemsRun = filteredData;
      });
    }

    up() {
      return Container(
        height: 160,
        decoration: BoxDecoration(
            color: Color.fromARGB(40, 0, 0, 0),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        child: SafeArea(
          child: Column(
            children: [
              head(),
              Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onTap: () {
                    setState(() {
                      searchFocus.requestFocus();
                      isFocused = true;
                    });
                  },
                  controller: _studentSearch,
                  onChanged: (value) => runFilter(),
                  focusNode: searchFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 62, 61, 61), width: 2),
                    ),
                    // filled: true,
                    // focusColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    hintText: "Search",
                    suffixIcon: isFocused
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isFocused = false;
                                _studentSearch.clear();
                                fetchRecord();
                                searchFocus.unfocus();
                                selectedArea = false;
                              });
                            },
                            icon: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(500)),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black87,
                                  size: 20,
                                )))
                        : Icon(Icons.search),
                    // prefix: Icon(Icons.search),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 108, 107, 107),
                            width: 2.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
      child: Column(
        children: [up(), studentList()],
      ),
    ));
  }
}
