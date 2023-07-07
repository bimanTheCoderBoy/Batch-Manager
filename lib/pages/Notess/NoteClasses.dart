import 'package:batch_manager/pages/Notess/NoteDao.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Notes.dart';

class AllClassesNote extends StatefulWidget {
  const AllClassesNote({super.key});

  @override
  State<AllClassesNote> createState() => _AllClassesNoteState();
}

class _AllClassesNoteState extends State<AllClassesNote> {
  List<dynamic>? classes;
  load() async {
    classes = await getClasses();
    if (classes == null) {
      classes = [];
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    load();
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
      child: Material(
        color: Colors.transparent,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
            title:
                Text("Choose Class", style: GoogleFonts.hubballi(fontSize: 25)),
          ),
          body: classes == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : classes!.length == 0
                  ? Center(
                      child: Text("No Classes Found"),
                    )
                  : ListView.builder(
                      itemCount: classes!.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(4),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    Notes("files/${classes![index]}"),
                              ),
                            );
                          },
                          child: Card(
                            child: Container(
                                constraints: BoxConstraints(minHeight: 50),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5,
                                                spreadRadius: 1)
                                          ],
                                          color: Colors.cyan,
                                          borderRadius:
                                              BorderRadius.circular(500)),
                                      child: Center(
                                        child: Text(
                                          "C",
                                          style: GoogleFonts.actor(
                                              color: Colors.white,
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "${classes![index]}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
