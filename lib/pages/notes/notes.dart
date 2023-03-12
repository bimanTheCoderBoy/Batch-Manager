import 'package:batch_manager/pages/notes/sendpdf/sendfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'viewpdf/viewpdf.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  var pageSelect = "View";
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
                "${pageSelect} Notes",
                style: GoogleFonts.hubballi(fontSize: 25),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Container(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  padding: EdgeInsets.only(right: 40, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(7)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Radio(
                              value: "View",
                              groupValue: pageSelect,
                              onChanged: (value) {
                                setState(() {
                                  pageSelect = value.toString();
                                });
                              },
                            ),
                            Text("View")
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Upload",
                            groupValue: pageSelect,
                            onChanged: (value) {
                              setState(() {
                                pageSelect = value.toString();
                              });
                            },
                          ),
                          Text('Upload')
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: (pageSelect == "Upload") ? SendFile() : ViewPdf())
              ]),
            )));
  }
}
