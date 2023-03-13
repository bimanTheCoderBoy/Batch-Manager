import 'package:batch_manager/pages/exam/addExam.dart';
import 'package:batch_manager/pages/exam/exam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'exam.dart';

class ExamMark extends StatefulWidget {
  var exam;
  ExamMark({super.key, required this.exam});
  var markDistributionArray = [];
  bool loading = false;
  arrayLoading() async {
    markDistributionArray = await ExamMethods.getExamStudent(exam);
  }

  @override
  State<ExamMark> createState() => _ExamMarkState();
}

class _ExamMarkState extends State<ExamMark> {
  // var exam;
  // _ExamMarkState(this.exam);

  var distributionArray = [];
  List<bool> edit = [];
  changeLoadingArrayLoading() async {
    setState(() {
      widget.loading = true;
    });
    await widget.arrayLoading();
    distributionArray = widget.markDistributionArray;
    for (var e in distributionArray) {
      edit.add(false);
    }
    setState(() {
      widget.loading = false;
    });
  }

  changeObjectValue(value, index) async {
    //object change only
    setState(() {
      distributionArray[index]['sMark'] = value;
    });
  }

  @override
  void initState() {
    changeLoadingArrayLoading();
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
              leading: BackButton(color: Colors.black),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              title: Text(
                "Mark Distribution",
                style: GoogleFonts.hubballi(fontSize: 25),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Container(
              child: widget.loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : distributionArray.length == 0
                      ? Center(
                          child: Text(
                            "No result found",
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : ListView.builder(
                          itemCount: distributionArray.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 8),
                              child: Row(children: [
                                Expanded(
                                    flex: 8,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Name : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      224, 73, 134, 255)),
                                            ),
                                            Text(ExamMethods.name(
                                                distributionArray[index]
                                                    ['sName'])),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Batch : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      224, 73, 134, 255)),
                                            ),
                                            Text(distributionArray[index]
                                                ['sBatch']),
                                          ],
                                        )
                                      ],
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: edit[index]
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: TextField(
                                            onSubmitted: (value) async {
                                              await changeObjectValue(
                                                  value, index);
                                              ExamMethods.studentMarkUpdate(
                                                  value,
                                                  distributionArray[index]
                                                      ['sId'],
                                                  widget.exam['examName']);
                                              if (index + 1 <
                                                  distributionArray.length) {
                                                setState(() {
                                                  edit[index + 1] = true;
                                                  edit[index] = false;
                                                });
                                              } else {
                                                setState(() {
                                                  edit[index] = false;
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,

                                            textInputAction: (index ==
                                                    distributionArray.length -
                                                        1)
                                                ? TextInputAction.done
                                                : TextInputAction.next,
                                            autofocus: true,
                                            // expands: true,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              edit[index] = true;
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "${distributionArray[index]['sMark']}",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      224, 73, 134, 255)),
                                            ),
                                          ),
                                        ),
                                )
                              ]),
                            );
                          },
                        ),
            )));
  }
}
