import 'package:batch_manager/main.dart';
import 'package:batch_manager/pages/quiz/Question.dart';
import 'package:batch_manager/pages/quiz/Quiz.dart';
import 'package:batch_manager/pages/quiz/dao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromARGB(255, 28, 28, 28),
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _id = TextEditingController();
  var _name = TextEditingController();
  var _time = TextEditingController();
  List batches = [];
  Quiz quiz = Quiz();
  List<Quiz> Quizes = [];
  List<bool> switchArray = [];
  late String dropdownvalue;
  int batchCount = 0;
  dropDownBatchdata() async {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference dropDown = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("Batches");
    var allData = await dropDown.get();
    var data = allData.docs.map((e) {
      batchCount += 1;

      return {"name": e['name'], "value": false};
    }).toList();
    if (batchCount > 0) {
      batches = [...data];
      dropdownvalue = batches[0]['name'];
    }
  }

  setSwitchArray() {
    for (int i = 0; i < Quizes.length; i++) {
      DateTime nowTime = DateTime.now();
      DateTime? lastOnTime = Quizes[i].switchTime;
      Duration? diff;
      if (lastOnTime == null) {
        switchArray.add(false);
      } else {
        diff = nowTime.difference(lastOnTime);
        int miniutes = diff.inMinutes;
        int quizTime = int.parse(Quizes[i].time as String);

        if (miniutes < quizTime) {
          switchArray.add(true);
        } else {
          switchArray.add(false);
        }
      }
    }
  }

  load() async {
    Quizes = await readQuizes();
    setSwitchArray();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropDownBatchdata();
    load();
  }

  @override
  Widget build(BuildContext context) {
//
    openAddStudentDialogue() => showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(
                  builder: (context, setStateSB) => Dialog(
                        insetPadding: EdgeInsets.all(10),
                        clipBehavior: Clip.hardEdge,
                        insetAnimationDuration: Duration(milliseconds: 100),
                        insetAnimationCurve: Curves.elasticInOut,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                                              color: Colors.blue, width: 3))),
                                  child: GradientText(
                                    "Create Quiz",
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
                                    controller: _id,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        label: Text("id"),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1.5)),
                                        prefixIcon: Icon(
                                          Icons.numbers,
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
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    controller: _name,
                                    decoration: InputDecoration(
                                        label: Text("name"),
                                        // hintText: "mobile",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1.5)),
                                        prefixIcon: Icon(
                                          Icons.book,
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
                                    controller: _time,
                                    decoration: InputDecoration(
                                        label: Text("time (minutes)"),
                                        // hintText: "mobile",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1.5)),
                                        prefixIcon: Icon(
                                          Icons.timer,
                                          color: Color.fromARGB(
                                              255, 140, 140, 140),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                182, 73, 134, 255),
                                            width: 2)),
                                    child: batches.length == 0
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ListView.builder(
                                            itemCount: batches.length,
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
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.black12,
                                                        width: 2)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '${batches[index]['name']}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Checkbox(
                                                      value: batches[index]
                                                          ['value'],
                                                      onChanged: (value) {
                                                        // setState(() {
                                                        //   batches[index]
                                                        //           ['value'] =
                                                        //       value as bool;
                                                        // });
                                                        setStateSB(
                                                          () {
                                                            batches[index]
                                                                    ['value'] =
                                                                value as bool;
                                                          },
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )),
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
                                            _id.clear();
                                            _name.clear();
                                            _time.clear();
                                            Navigator.pop(context);
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
                                          onPressed: () async {
                                            List<String> quizbatch = [];
                                            for (var element in batches) {
                                              if (element['value']) {
                                                quizbatch.add(element['name']);
                                              }
                                            }
                                            quiz.batches = quizbatch;
                                            quiz.id = _id.text.trim();
                                            quiz.name = _name.text.trim();
                                            quiz.time = _time.text.trim();
                                            setState(() {
                                              quiz.questions = [];
                                            });
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateQuizPage(
                                                          quiz, false)),
                                            );
                                            setState(() {
                                              _id.clear();
                                              _name.clear();
                                              _time.clear();
                                              quiz.questions = [];
                                            });
                                          },
                                          child: GradientText(
                                            "Proceed",
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

    ///

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => navgatorKey.currentState!.pop(),
        ),
        title: Text('Quizes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await openAddStudentDialogue();
              load();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CreateQuizPage()),
              // );
            },
          ),
        ],
      ),
      body: Center(
          child: Quizes.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: Quizes.length,
                  itemBuilder: (context, index) {
                    // bool switchvalue = false;
                    return TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                CreateQuizPage(Quizes[index], true),
                          ),
                        );
                        load();
                      },
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: Color.fromARGB(192, 145, 145, 145),
                        shadowColor: Colors.black54,
                        elevation: 15,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${Quizes[index].name as String}"
                                                    .length <=
                                                25
                                            ? "${Quizes[index].name as String}"
                                            : "${Quizes[index].name as String}"
                                                    .substring(0, 23) +
                                                "..",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 31, 31, 31),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            color:
                                                Color.fromARGB(255, 195, 14, 2),
                                          ),
                                          Text(
                                              "${Quizes[index].time as String} minutes",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 31, 31, 31),
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blueGrey[700]),
                                              onPressed: () {},
                                              child: Text(
                                                "Results",
                                                style: TextStyle(
                                                    color: Colors.amber),
                                              )),
                                          Expanded(flex: 1, child: SizedBox()),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      insetPadding:
                                                          EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        // alignment: Alignment.center,
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            20),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Are you sure, you want to delete ?",
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          67,
                                                                          87,
                                                                          97),
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
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Color.fromARGB(182, 184, 35, 35),
                                                                          side: BorderSide(color: Color.fromARGB(255, 32, 32, 32), width: 1.5),
                                                                          shape: RoundedRectangleBorder(
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
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            }));
                                                                        await deleteQuiz(
                                                                            Quizes[index]);
                                                                        Navigator.pop(
                                                                            context);

                                                                        Navigator.pop(
                                                                            context);
                                                                        load();
                                                                      }),
                                                                      child:
                                                                          Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                221,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 43,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                                                          side: BorderSide(color: Color.fromARGB(255, 165, 165, 165), width: 1.5),
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(7), // <-- Radius
                                                                          )),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 20),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            500),
                                                    color: Color.fromARGB(
                                                        255, 58, 76, 85)),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Color.fromARGB(
                                                      255, 221, 17, 3),
                                                ),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                // width: 100,
                                height: 110,
                                color: Colors.black45,
                                child: Center(
                                    child: Switch(
                                  value: switchArray[index],
                                  onChanged: (value) async {
                                    if (!switchArray[index]) {
                                      Quizes[index].switchTime = DateTime.now();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                "Database Processing..",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                      await addquiz(Quizes[index]);
                                      // Navigator.pop(context);
                                      navgatorKey.currentState!.pop(context);
                                      // load();
                                      // Navigator.pop(context);
                                    }
                                    setState(() {
                                      switchArray[index] = value;
                                    });
                                  },
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}

class CreateQuizPage extends StatefulWidget {
  Quiz quiz;
  bool update = false;
  CreateQuizPage(this.quiz, this.update);

  @override
  State<CreateQuizPage> createState() => _CreateQuizAppState(quiz, update);
}

class _CreateQuizAppState extends State<CreateQuizPage> {
  Quiz quiz;
  bool update;
  _CreateQuizAppState(this.quiz, this.update);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(166, 0, 0, 0),
        title: Text('All Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuestionPage(quiz)),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quiz.questions.length, // Number of questions
              itemBuilder: (context, index) {
                String _correctAnswer = '1';
                List<String> keys = [];
                String vle = '1';
                int ind = 1;
                quiz.questions[index].answers.forEach((key, value) {
                  keys.add(key);
                  if (value) {
                    vle = ind.toString();
                  }
                  ind = ind + 1;
                });
                _correctAnswer = vle;
                return Card(
                  elevation: 13,
                  margin: EdgeInsets.all(10),
                  color: Color.fromARGB(192, 145, 145, 145),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.questions[index].name as String,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          keys[0],
                          style: TextStyle(
                            color: Color.fromARGB(210, 0, 0, 0),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          keys[1],
                          style: TextStyle(
                            color: Color.fromARGB(210, 0, 0, 0),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          keys[2],
                          style: TextStyle(
                            color: Color.fromARGB(210, 0, 0, 0),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          keys[3],
                          style: TextStyle(
                            color: Color.fromARGB(210, 0, 0, 0),
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 88,
                              child: DropdownButtonFormField<String>(
                                borderRadius: BorderRadius.circular(10),
                                value: _correctAnswer,
                                onChanged: (value) {
                                  int ind = 1;
                                  quiz.questions[index].answers
                                      .forEach((key, vlue) {
                                    if (ind.toString() == value) {
                                      quiz.questions[index].answers[key] = true;
                                    } else {
                                      quiz.questions[index].answers[key] =
                                          false;
                                    }
                                    ind = ind + 1;
                                  });

                                  setState(() {
                                    _correctAnswer = value!;
                                  });
                                },
                                items: ['1', '2', '3', '4']
                                    .map((option) => DropdownMenuItem(
                                          // alignment: Alignment.center,
                                          value: option,
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    252, 82, 82, 82)),
                                          ),
                                        ))
                                    .toList(),
                                decoration: const InputDecoration(
                                  labelText: 'Correct Answer',
                                  labelStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black54, width: 1.5)),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    quiz.questions
                                        .remove(quiz.questions[index]);
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 201, 15, 1),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
              onPressed: () async {
                if (!update) {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }));
                }
                await addquiz(quiz);
                if (update) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }

                // TODO: Save quiz to Firestore
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 220,
                child: update ? Text('Update Quiz') : Text('Save Quiz'),
              )),
        ],
      ),
    );
  }
}

class AddQuestionPage extends StatefulWidget {
  Quiz quiz;
  AddQuestionPage(this.quiz);
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState(quiz);
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  Quiz quiz;
  _AddQuestionPageState(this.quiz);
  String _selectedCorrectAnswer = '1';
  String question = 'q';
  String answer1 = 'q1';
  String answer2 = 'q2';
  String answer3 = 'q3';
  String answer4 = 'q4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(166, 0, 0, 0),
        title: Text(quiz.name as String),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 18, color: Colors.black87),
                onChanged: (value) {
                  question = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Question',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                  ),

                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black54, width: 1.5)),
                  // focusedBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.cyan),
                  // ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 1,
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.black54),
                onChanged: (value) {
                  answer1 = value;
                },
                decoration: InputDecoration(
                  labelText: 'Answer 1',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black54, width: 1.5)),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                minLines: 1,
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.black54),
                onChanged: (value) {
                  answer2 = value;
                },
                decoration: InputDecoration(
                  labelText: 'Answer 2',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black54, width: 1.5)),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                minLines: 1,
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.black54),
                onChanged: (value) {
                  answer3 = value;
                },
                decoration: InputDecoration(
                  labelText: 'Answer 3',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black54, width: 1.5)),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                minLines: 1,
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.black54),
                onChanged: (value) {
                  answer4 = value;
                },
                decoration: InputDecoration(
                  labelText: 'Answer 4',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black54, width: 1.5)),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                minLines: 1,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(10),
                    value: _selectedCorrectAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedCorrectAnswer = value!;
                      });
                    },
                    items: ['1', '2', '3', '4']
                        .map((option) => DropdownMenuItem(
                              // alignment: Alignment.center,
                              value: option,
                              child: Text(
                                option,
                                style: TextStyle(
                                    color: Color.fromARGB(253, 0, 109, 36)),
                              ),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Correct Answer',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1.5)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700]),
                onPressed: () {
                  Question qtn = Question();
                  qtn.name = question;
                  Map<String, bool> map = {};

                  map[answer1] = (_selectedCorrectAnswer == '1');
                  map[answer2] = (_selectedCorrectAnswer == '2');
                  map[answer3] = (_selectedCorrectAnswer == '3');
                  map[answer4] = (_selectedCorrectAnswer == '4');
                  qtn.answers = map;
                  quiz.questions.add(qtn);
                  Navigator.pop(context);
                  // TODO: Add question logic
                },
                child: Container(
                    height: 50, child: Center(child: Text('Add Question'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
