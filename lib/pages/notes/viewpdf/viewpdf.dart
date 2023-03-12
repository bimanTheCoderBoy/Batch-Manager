import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../fileMethod.dart';

class ViewPdf extends StatefulWidget {
  const ViewPdf({super.key});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  List classs = [];
  classUpdate() async {
    classs = await Note.getClasses();
    setState(() {
      classs = classs;
    });
  }

  @override
  void initState() {
    classUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20),
      child: Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Classes",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(182, 73, 134, 255),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 15, top: 10),
                child: classs.length == 0
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: classs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 15),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 160, 191, 215),
                                      spreadRadius: 0.5,
                                      blurRadius: 3)
                                ]),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black54,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                onPressed: () {},
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${classs[index]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                )),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
