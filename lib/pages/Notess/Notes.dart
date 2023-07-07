// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';

import 'package:batch_manager/pages/Notess/NoteDao.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'openPdf.dart';
// import 'sendfile.dart';

class Notes extends StatefulWidget {
  String url;
  Notes(this.url, {super.key});

  @override
  State<Notes> createState() => _NotesState(url);
}

class _NotesState extends State<Notes> {
  String url;
  List<NoteCumFolder>? refList;
  File? uploadFile;
  UploadTask? task;
  String createfolderTextControler = '';
  _NotesState(this.url);
  load() async {
    print(url);
    refList = await getAllNotesAndFolder(url);
    refList ??= [];
    if (mounted) {
      setState(() {});
    }
  }

  //upload PDF
  UploadTask? uploadPdf(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);

      // return ref.putFile(file);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

//uploadFile
  Future uploadPdfFile() async {
    if (uploadFile == null) {
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

    final fileName = basename(uploadFile!.path);

    final destination = "${url}/${fileName}";

    task = uploadPdf(destination, uploadFile!);
    // if (mounted) {
    //   setState(() {});
    // }

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
    if (mounted) {
      load();
      setState(() {
        uploadFile = null;
        task = null;
      });
    } // print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 17),
            );
          } else {
            return Container();
          }
        },
      );
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    checkLocal(String path) async {
      final filename = basename(path);
      final dir = await getApplicationDocumentsDirectory();
      File? file;
      try {
        file = File('${dir.path}/$filename');
      } catch (e) {
        file = null;
      }

      return await (file!.exists()) ? file : null;
    }

//open pdf pdf loading
    Future<File> _storeFile(
        String url, List<int> bytes, BuildContext context) async {
      final filename = basename(url);
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);
      Navigator.pop(context);
      return file;
    }

    Future<File?> loadFirebase(String url, BuildContext context) async {
      showDialog(
          context: context,
          builder: ((context) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "Loading PDF from Database..",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            );
          }));
      try {
        final refPDF = FirebaseStorage.instance.ref("${url}");
        final bytes = await refPDF.getData();

        return _storeFile("$url", bytes!, context);
      } catch (e) {
        return null;
      }
    }

    void openPDF(BuildContext context, File file) => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
        );
//file upload Dialog
    uploadPdfDialog() => showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(
                builder: (context, setStateSB) => Dialog(
                  insetPadding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  child: Container(
                    margin: EdgeInsets.all(0),
                    constraints: BoxConstraints(minHeight: 150),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            uploadFile = await selectFile();
                            if (mounted) {
                              setStateSB(() {});
                            }
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
                        Text((uploadFile == null)
                            ? "No File Selected"
                            : basename(uploadFile!.path)),
                        if (task != null)
                          Container(
                              child: Center(
                                  child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("uploading.."),
                                  buildUploadStatus(task!),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ))),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  // side: BorderSide(color: Colors.red
                                  // )
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                // Navigator.pop(context);
                                Navigator.of(context).pop(false);
                              },
                              child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )),
                            ),
                            Expanded(flex: 1, child: SizedBox()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 233, 192, 58),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  // side: BorderSide(color: Colors.red
                                  // )
                                ),
                              ),
                              onPressed: () async {
                                // Navigator.pop(context);
                                // Navigator.pop(context);
                                var upload = uploadPdfFile();
                                setStateSB(() {});
                                await upload;
                                Navigator.of(context).pop(true);
                              },
                              child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Upload",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        transitionDuration: Duration(milliseconds: 150),
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Text("page builder");
        });
    createFolderDialog() => showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(
                builder: (context, setStateSB) => Dialog(
                  insetPadding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  child: Container(
                      constraints: BoxConstraints(minHeight: 150),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Create Folder",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              createfolderTextControler = value;
                            },
                            decoration: InputDecoration(
                                labelText: "type folder name...",
                                floatingLabelStyle:
                                    TextStyle(color: Colors.blueGrey),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey, width: 1.5)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  // side: BorderSide(color: Colors.red
                                  // )
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                // Navigator.pop(context);
                                Navigator.of(context).pop(false);
                              },
                              child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )),
                            ),
                            Expanded(flex: 1, child: SizedBox()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 233, 192, 58),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  // side: BorderSide(color: Colors.red
                                  // )
                                ),
                              ),
                              onPressed: () async {
                                // Navigator.pop(context);
                                // Navigator.pop(context);
                                await createEmptyFolder(
                                    "${url}/${createfolderTextControler}");

                                print("${url}/${createfolderTextControler}");
                                Navigator.of(context).pop(true);
                                load();
                              },
                              child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Create",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ])),
                ),
              ),
            ),
        transitionDuration: Duration(milliseconds: 150),
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Text("page builder");
        });
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
              elevation: 0,
              // centerTitle: true,
              title: Text("Notes", style: GoogleFonts.hubballi(fontSize: 25)),
              actions: [
                IconButton(
                    onPressed: () {
                      createFolderDialog();
                    },
                    splashColor: Color.fromARGB(87, 33, 149, 243),
                    icon: Icon(
                      Icons.folder_copy,
                      color: Color.fromARGB(173, 0, 0, 0),
                    )),
                IconButton(
                    onPressed: () {
                      uploadPdfDialog();
                    },
                    splashColor: Color.fromARGB(87, 33, 149, 243),
                    icon: Icon(
                      Icons.upload_file,
                      color: Color.fromARGB(173, 0, 0, 0),
                    ))
              ],
            ),
            body: refList == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : refList!.isEmpty
                    ? Center(
                        child: Text("No Data Found"),
                      )
                    : ListView.builder(
                        itemCount: refList!.length,
                        itemBuilder: (context, index) {
                          return TextButton(
                            onPressed: () async {
                              if (refList![index].isNote) {
                                var file = await checkLocal(
                                    refList![index].data.fullPath);
                                if (file == null) {
                                  file = await loadFirebase(
                                      refList![index].data.fullPath, context);
                                }

                                if (file != null) {
                                  openPDF(context, file);
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Notes(refList![index].data.fullPath),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(4)),
                            child: Card(
                              child: Container(
                                  constraints: BoxConstraints(minHeight: 50),
                                  // height: 50,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      refList![index].isNote
                                          ? Image.asset(
                                              "assets/images/pdfimg.png",
                                              scale: 7,
                                            )
                                          : Image.asset(
                                              "assets/images/folderimg.png",
                                              scale: 8,
                                            ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: SingleChildScrollView(
                                            child:
                                                Text(refList![index].data.name),
                                          ),
                                        ),
                                      ),
                                      if (refList![index].isNote)
                                        IconButton(
                                          splashColor:
                                              Color.fromARGB(88, 244, 67, 54),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                    insetPadding:
                                                        EdgeInsets.all(15),
                                                    // backgroundColor: AppColors.appBar,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Text(
                                                            "Do you want to Delete this file ?",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  left: 25,
                                                                  right: 25,
                                                                  bottom: 15),
                                                          child: Row(
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.red[
                                                                          700],
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    // side: BorderSide(color: Colors.red
                                                                    // )
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  // Navigator.pop(context);
                                                                  // Navigator.pop(context);
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                                  );

                                                                  await refList![
                                                                          index]
                                                                      .data
                                                                      .delete();

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  load();
                                                                },
                                                                child: Container(
                                                                    height: 40,
                                                                    child: Center(
                                                                      child:
                                                                          Text(
                                                                        "Delete",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18),
                                                                      ),
                                                                    )),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    SizedBox(),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blueGrey,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    // side: BorderSide(color: Colors.red
                                                                    // )
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  // Navigator.pop(context);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false);
                                                                },
                                                                child: Container(
                                                                    height: 40,
                                                                    child: Center(
                                                                      child:
                                                                          Text(
                                                                        "No",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18),
                                                                      ),
                                                                    )),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          icon: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          120, 158, 158, 158),
                                                      spreadRadius: 0.5,
                                                      blurRadius: 4)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(500)),
                                            child: Center(
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.red[400],
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  )),
                            ),
                          );
                        },
                      )));
  }
}
