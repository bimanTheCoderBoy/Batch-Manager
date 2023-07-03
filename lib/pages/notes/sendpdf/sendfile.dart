import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_upload_example/api/firebase_api.dart';
// import 'package:firebase_upload_example/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

class SendFile extends StatefulWidget {
  const SendFile({super.key});

  @override
  State<SendFile> createState() => _SendFileState();
}

class _SendFileState extends State<SendFile> {
  UploadTask? task;
  File? file;
  bool isDispose = false;
  @override
  void dispose() {
    isDispose = true;
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  void initState() {
    getClasses();
    super.initState();
  }

  Future selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false);

      if (result == null) return;
      final path = result.files.single.path!;
      if (!isDispose) {
        setState(() => file = File(path));
      }
    } catch (e) {
      print(e);
    }
  }

//upload file
  UploadTask? uploadPdf(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref('').child(destination);

      return ref.putFile(file);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

//uploadFile
  Future uploadFile() async {
    if (file == null) {
      Fluttertoast.showToast(
          msg: "No File Selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 63, 161, 189),
          textColor: Color.fromARGB(255, 226, 226, 226),
          fontSize: 16.0);
      return;
    }

    final fileName = basename(file!.path);

    final destination = 'files/${chooseClass}/${fileName}';

    task = uploadPdf(destination, file!);
    if (!isDispose) {
      setState(() {});
    }

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {
      Fluttertoast.showToast(
          msg: "Upload complete!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 10, 138, 40),
          textColor: Color.fromARGB(255, 226, 226, 226),
          fontSize: 16.0);
    });
    // final urlDownload = await snapshot.ref.getDownloadURL();
    if (!isDispose) {
      setState(() {
        file = null;
        task = null;
        getClasses();
      });
    }
    // print('Download-Link: $urlDownload');
  }

//findclasses

  List classes = [];
  var chooseClass = "";
  getClasses() async {
    var user = FirebaseAuth.instance.currentUser;
    var batchInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Batches')
        .get();
    // for (var ele in batchInstance.docs) {
    //   classes.add(ele.data()['class']);

    // }
    classes = batchInstance.docs.map((e) => e.data()['class']).toSet().toList();

    if (classes.isNotEmpty && !isDispose) {
      setState(() {
        chooseClass = classes[0];
      });
    }
    if (!isDispose) {
      setState(() {
        classes;
      });
    }
  }

//status
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          await selectFile();
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 10, top: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(182, 73, 134, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Choose Pdf",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Center(
                          child: Text(fileName),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
            Container(
              // decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Text(
                              "Choose Class",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(182, 73, 134, 255)),
                            ),
                          ],
                        ),
                        Container(
                            height: 270,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            // padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(182, 73, 134, 255),
                                    width: 2)),
                            child: classes.length == 0
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: classes.length,
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
                                              '${classes[index]}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Radio(
                                              value: '${classes[index]}',
                                              groupValue: chooseClass,
                                              onChanged: (value) {
                                                if (!isDispose) {
                                                  setState(() {
                                                    chooseClass =
                                                        value as String;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                        TextButton(
                          onPressed: () => uploadFile(),
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(182, 73, 134, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Upload Pdf",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        task != null ? buildUploadStatus(task!) : Container(),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
