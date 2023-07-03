// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:batch_manager/pages/notes/viewpdf/openPdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class Pdfs extends StatefulWidget {
  var path;
  Pdfs({super.key, required this.path});

  @override
  State<Pdfs> createState() => _PdfsState(path);
}

class _PdfsState extends State<Pdfs> {
  bool isDispose = false;
  @override
  void dispose() {
    // ignore: avoid_print
    isDispose = true;
    print('Dispose used');
    super.dispose();
  }

  var path;
  List refList = [];
  List delArray = [];
  bool loading = true;
  bool loadingOpen = false;
  _PdfsState(this.path);
  @override
  void initState() {
    listAll();
    super.initState();
  }

  listAll() async {
    ListResult result = await FirebaseStorage.instance.ref(path).listAll();
    delArray.clear();
    refList.clear();
    result.items.forEach((Reference ref) {
      delArray.add(false);
      refList.add(ref);
    });
    if (!isDispose) {
      setState(() {
        refList = refList;
        loading = false;
      });
    }
  }

  Future<File?> loadFirebase(String url, BuildContext context) async {
    showDialog(
        context: context,
        builder: ((context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
    try {
      final refPDF = FirebaseStorage.instance.ref("${path}/${url}");
      final bytes = await refPDF.getData();

      return _storeFile("${path}/${url}", bytes!, context);
    } catch (e) {
      return null;
    }
  }

  Future<File> _storeFile(
      String url, List<int> bytes, BuildContext context) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    Navigator.pop(context);
    return file;
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );

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
                path.toString().substring(6),
                style: GoogleFonts.hubballi(fontSize: 25),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : refList.length == 0
                    ? Center(
                        child: Text("No results found"),
                      )
                    : ListView.builder(
                        itemCount: refList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              TextButton(
                                  onLongPress: () {
                                    if (!isDispose) {
                                      setState(() {
                                        delArray[index] = true;
                                      });
                                    }
                                  },
                                  onPressed: () async {
                                    if (!isDispose) {
                                      setState(() {
                                        loadingOpen = true;
                                      });
                                    }
                                    File? file = await loadFirebase(
                                        refList[index].name, context);
                                    if (file != null) {
                                      openPDF(context, file);
                                    }
                                    loadingOpen = false;
                                  },
                                  child: Container(
                                      height: 60,
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Text("${refList[index].name}"))),
                              if (delArray.isNotEmpty && delArray[index])
                                Container(
                                  height: 62,
                                  margin: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 5, top: 6),
                                  padding: EdgeInsets.only(left: 40, right: 40),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(183, 37, 37, 37),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 252, 183, 34),
                                      ),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor:
                                                Color.fromARGB(175, 49, 48, 48),
                                            fixedSize: Size(30, 30)),
                                        onPressed: (() {
                                          if (!isDispose) {
                                            setState(() {
                                              delArray[index] = false;
                                            });
                                          }
                                        }),
                                        child: Icon(Icons.close),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor: Color.fromARGB(
                                                158, 244, 83, 65),
                                            fixedSize: Size(30, 30)),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  // alignment: Alignment.center,
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Are you sure, you want to delete ?",
                                                            style: GoogleFonts
                                                                .hubballi(
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor: Color.fromARGB(
                                                                            203,
                                                                            145,
                                                                            2,
                                                                            2),
                                                                        side: BorderSide(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                32,
                                                                                32,
                                                                                32),
                                                                            width:
                                                                                1.5),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7), // <-- Radius
                                                                        )),
                                                                onPressed:
                                                                    (() async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          ((context) {
                                                                        return Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        );
                                                                      }));
                                                                  await refList[
                                                                          index]
                                                                      .delete();

                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  delArray[
                                                                          index] =
                                                                      false;
                                                                  loading =
                                                                      true;
                                                                  await listAll();
                                                                }),
                                                                child: Text(
                                                                  "Yes",
                                                                  style: GoogleFonts.hubballi(
                                                                      color: Color.fromARGB(
                                                                          221,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 43,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        side: BorderSide(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                165,
                                                                                165,
                                                                                165),
                                                                            width:
                                                                                1.5),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7), // <-- Radius
                                                                        )),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  if (!isDispose) {
                                                                    setState(
                                                                        () {
                                                                      delArray[
                                                                              index] =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "No",
                                                                  style: GoogleFonts.hubballi(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25),
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
                                        child: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          );
                        },
                      )));
  }
}
