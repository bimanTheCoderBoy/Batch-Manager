import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

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
  var _massage = TextEditingController();
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

  send(String massage) async {
    bool selectedOrNot = false;
    var user = FirebaseAuth.instance.currentUser;
    for (var e in batches) {
      if (e.value == true) {
        selectedOrNot = true;
        var batchInstance = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('Batches')
            .doc(e.id)
            .get();
        var batchArray = batchInstance.data()?["batchArray"];
        var newm = {
          "massage": massage,
          "date": DateTime.now().toLocal().toString().substring(0, 10),
          "time": "${DateTime.now().hour}:${DateTime.now().minute}"
        };
        if (batchArray == null) {
          batchArray = [newm];
        } else {
          batchArray.add(newm);
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Batches')
            .doc(e.id)
            .update({"batchArray": batchArray});
        setState(() {
          e.value = false;
        });
      }
    }
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
    batchLoading();
    super.initState();
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
                      height: 280,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black12, width: 2)),
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
