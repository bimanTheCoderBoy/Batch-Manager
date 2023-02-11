import 'package:batch_manager/pages/batches_page.dart';
import 'package:batch_manager/pages/student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:themed/themed.dart';

class HomePagee extends StatefulWidget {
  const HomePagee({super.key});

  @override
  State<HomePagee> createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePagee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SafeArea(
              child: Container(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  alignment: Alignment.topLeft,
                  height: 100,
                  child: Text(
                    "'Welcome\nTo Batch Manager'",
                    style: GoogleFonts.hubballi(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54),
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Material(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Color.fromARGB(0, 255, 193, 7),
                            child: IconButton(
                                splashColor: Color.fromARGB(80, 0, 0, 0),
                                alignment: Alignment.center,
                                iconSize: 30,
                                onPressed: () {},
                                icon: InkWell(
                                  splashColor: Color.fromARGB(80, 0, 0, 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  95, 70, 70, 70),
                                              blurRadius: 1,
                                              spreadRadius: 2,
                                              offset: Offset(0, 0))
                                        ],
                                        color: Color.fromARGB(0, 244, 109, 109),
                                        borderRadius:
                                            BorderRadius.circular(300)),
                                    child: Icon(
                                      Icons.notifications_active,
                                      size: 26,
                                      color: Colors.white70,
                                    ),
                                  ),
                                )),
                          ),
                          Material(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2000)),
                            color: Color.fromARGB(0, 255, 193, 7),
                            child: IconButton(
                                splashColor: Color.fromARGB(80, 0, 0, 0),
                                alignment: Alignment.center,
                                iconSize: 47,
                                onPressed: () {},
                                icon: InkWell(
                                  splashColor: Color.fromARGB(80, 0, 0, 0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    95, 70, 70, 70),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                                offset: Offset(0, 0))
                                          ],
                                          color: Colors.white54,
                                          borderRadius:
                                              BorderRadius.circular(300)),
                                      child: Center(
                                        child: Text(
                                          "B",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Row(),
                    Container(
                      height: 250,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 30),
                      decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(70),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(70),
                            bottomRight: Radius.circular(10),
                          )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15, top: 15),
                                child: CircularPercentIndicator(
                                  animation: true,
                                  animationDuration: 2000,
                                  radius: 90,
                                  lineWidth: 10,
                                  percent: 0.8,
                                  progressColor:
                                      Color.fromARGB(255, 206, 137, 137),
                                  backgroundColor:
                                      Color.fromARGB(255, 219, 181, 181),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  center: Text(
                                    "80%",
                                    style: GoogleFonts.hubballi(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20, top: 17),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Monthly Earning",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "2005",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(160, 0, 103, 38)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            margin:
                                EdgeInsets.only(left: 20, right: 19, top: 25),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(5))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Due :",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      "20045",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(137, 137, 0, 0)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Expected M.E :",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      "2555",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(160, 1, 33, 122)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total :",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      "5445",
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(160, 1, 33, 122)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 15, right: 15),
                    //         child: Image.asset(
                    //           "assets/images/chem5.png",
                    //           scale: 3,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 40, right: 25),
                    //         child: Image.asset(
                    //           "assets/images/chem1.png",
                    //           scale: 5,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(flex: 1, child: Container()),

                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Container(
                          height: 70,
                          padding:
                              EdgeInsets.only(bottom: 0, left: 20, right: 20),
                          decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(550)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Material(
                                    clipBehavior: Clip.hardEdge,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2000)),
                                    color: Color.fromARGB(0, 255, 193, 7),
                                    child: IconButton(
                                        splashColor:
                                            Color.fromARGB(80, 0, 0, 0),
                                        alignment: Alignment.center,
                                        iconSize: 47,
                                        onPressed: () {},
                                        icon: InkWell(
                                          splashColor:
                                              Color.fromARGB(80, 0, 0, 0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          95, 70, 70, 70),
                                                      blurRadius: 6,
                                                      spreadRadius: 2,
                                                      offset: Offset(0, 0))
                                                ],
                                                color: Color.fromARGB(
                                                    110, 244, 109, 109),
                                                borderRadius:
                                                    BorderRadius.circular(300)),
                                            child: Icon(
                                              Icons.currency_rupee,
                                              size: 26,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Positioned(
                                    top: 55,
                                    child: Text(
                                      "Finance",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Color.fromARGB(221, 35, 34, 34)),
                                    ),
                                  )
                                ],
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Material(
                                    clipBehavior: Clip.hardEdge,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2000)),
                                    color: Color.fromARGB(0, 255, 193, 7),
                                    child: IconButton(
                                        splashColor:
                                            Color.fromARGB(80, 0, 0, 0),
                                        alignment: Alignment.center,
                                        iconSize: 47,
                                        onPressed: () {},
                                        icon: InkWell(
                                          splashColor:
                                              Color.fromARGB(80, 0, 0, 0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          95, 70, 70, 70),
                                                      blurRadius: 6,
                                                      spreadRadius: 2,
                                                      offset: Offset(0, 0))
                                                ],
                                                color: Color.fromARGB(
                                                    110, 244, 109, 109),
                                                borderRadius:
                                                    BorderRadius.circular(300)),
                                            child: Icon(
                                              Icons.volume_up,
                                              size: 26,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Positioned(
                                    top: 55,
                                    child: Text(
                                      "Anouncement",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Color.fromARGB(221, 35, 34, 34)),
                                    ),
                                  )
                                ],
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Material(
                                    clipBehavior: Clip.hardEdge,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2000)),
                                    color: Color.fromARGB(0, 255, 193, 7),
                                    child: IconButton(
                                        splashColor:
                                            Color.fromARGB(80, 0, 0, 0),
                                        alignment: Alignment.center,
                                        iconSize: 47,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const BatchList(),
                                            ),
                                          );
                                        },
                                        icon: InkWell(
                                          splashColor:
                                              Color.fromARGB(80, 0, 0, 0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          95, 70, 70, 70),
                                                      blurRadius: 6,
                                                      spreadRadius: 2,
                                                      offset: Offset(0, 0))
                                                ],
                                                color: Color.fromARGB(
                                                    110, 244, 109, 109),
                                                borderRadius:
                                                    BorderRadius.circular(300)),
                                            child: Icon(
                                              Icons.people,
                                              size: 26,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Positioned(
                                    top: 55,
                                    child: Text(
                                      "Batch",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Color.fromARGB(221, 35, 34, 34)),
                                    ),
                                  )
                                ],
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Material(
                                    clipBehavior: Clip.hardEdge,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2000)),
                                    color: Color.fromARGB(0, 255, 193, 7),
                                    child: IconButton(
                                        splashColor:
                                            Color.fromARGB(80, 0, 0, 0),
                                        alignment: Alignment.center,
                                        iconSize: 47,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  Student(
                                                dueList: true,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: InkWell(
                                          splashColor:
                                              Color.fromARGB(80, 0, 0, 0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          95, 70, 70, 70),
                                                      blurRadius: 6,
                                                      spreadRadius: 2,
                                                      offset: Offset(0, 0))
                                                ],
                                                color: Color.fromARGB(
                                                    110, 244, 109, 109),
                                                borderRadius:
                                                    BorderRadius.circular(300)),
                                            child: Icon(
                                              Icons.person,
                                              size: 26,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Positioned(
                                    top: 55,
                                    child: Text(
                                      "Student",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Color.fromARGB(221, 35, 34, 34)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
