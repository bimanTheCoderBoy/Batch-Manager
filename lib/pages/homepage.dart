import 'package:batch_manager/pages/batches_page.dart';
import 'package:batch_manager/pages/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var user;
  dynamic userName = "U";
  dynamic useremail = " ";
  List userNotifications = [];
  var earningDetails = {
    "MonthlyEarning": 0,
    "Due": 0,
    "ExpectedME": 0,
    "Total": 0,
    "Parcentage": 0.1
  };
  load() async {
    user = FirebaseAuth.instance.currentUser;
    var userInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    userName = await userInstance.data()?['name'];
    userNotifications = await userInstance.data()?['notifications'];
    List userEarning = await userInstance.data()?['monthlyEarningArray'];
    earningDetails["Due"] = 0;
    dynamic me = 0;
    dynamic expectedMe = 0;
    List students = [];
    var studentInstance = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('student')
        .get();
    studentInstance.docs.map(
      (e) {
        if (e.data()["account"]?[0]?["isPaid"] ?? false == true) {
          me += e.data()["account"]?[0]?["dueMoney"] ?? 0;
        }

        expectedMe += e.data()["account"]?[0]?["dueMoney"] ?? 0;
        return ({});
      },
    ).toList();
    earningDetails["MonthlyEarning"] = await me;
    earningDetails["ExpectedME"] = await expectedMe;
    earningDetails["Total"] = await earningDetails["Due"]! + expectedMe as int;
    earningDetails["Parcentage"] = await (me / earningDetails["Total"]) * 100;
    double tt = earningDetails["Parcentage"] as double;

    earningDetails["Parcentage"] = tt.toInt();
    if (userEarning.length >= 1) {
      userEarning[0] = {
        "due": earningDetails["Due"],
        "expectedMe": earningDetails["ExpectedME"],
        "me": earningDetails["MonthlyEarning"],
        "total": earningDetails["Total"]
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({"monthlyEarningArray": userEarning});
    }

    setState(() {
      userName = userName;
      useremail = user.email;
      userNotifications = userNotifications;
      earningDetails = earningDetails;
    });
  }

  var userNameEditArea = true;
  var userNameEditControlar = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usernameOredit() {
      if (userNameEditArea) {
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              "  $userName",
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.black54,
              ),
            ));
      } else {
        return Container(
          width: MediaQuery.of(context).size.width * .6,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: TextField(
            autofocus: true,
            // expands: true,
            controller: userNameEditControlar,
          ),
        );
      }
    }

    notification() {
      return showGeneralDialog(
          context: context,
          transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(
                builder: (context, setStateSB) => Dialog(
                  insetPadding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color.fromARGB(232, 255, 255, 255),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Notifications",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(left: 200),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close)),
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: ListView.builder(
                                itemCount: userNotifications.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(85, 255, 165, 165),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Center(
                                                  child: Text(
                                                "${userNotifications[index]['body']}",
                                                style: GoogleFonts.lato(
                                                    color: Color.fromARGB(
                                                        160, 0, 0, 0),
                                                    fontSize: 16),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                  "${userNotifications[index]['time']}",
                                                  style: GoogleFonts.lato(
                                                      color: Color.fromARGB(
                                                          145, 0, 0, 0),
                                                      fontSize: 12)),
                                              Text(
                                                  "${userNotifications[index]['date']}",
                                                  style: GoogleFonts.lato(
                                                      color: Color.fromARGB(
                                                          145, 0, 0, 0),
                                                      fontSize: 12))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          transitionDuration: Duration(milliseconds: 150),
          barrierLabel: '',
          pageBuilder: (context, animation1, animation2) {
            return Text("page builder");
          });
    }

    accountBox() {
      return showGeneralDialog(
          context: context,
          transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: StatefulBuilder(
                builder: (context, setStateSB) => Dialog(
                  backgroundColor: Color.fromARGB(232, 255, 255, 255),
                  insetPadding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // backgroundColor: Colors.transparent,
                  // contentPadding: EdgeInsets.zero,
                  clipBehavior: Clip.hardEdge,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width - 30,
                      height: 194,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setStateSB(() {
                                      userNameEditArea = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(76, 255, 165, 165),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, bottom: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.black54,
                                          ),
                                          usernameOredit(),
                                        ],
                                      ),
                                      if (userNameEditArea)
                                        IconButton(
                                            onPressed: () {
                                              setStateSB(() {
                                                userNameEditArea = false;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.black54,
                                            ))
                                      else
                                        IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .update({
                                              "name":
                                                  "${userNameEditControlar.text} "
                                            });
                                            await load();
                                            setStateSB(() {
                                              userNameEditArea = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.update,
                                            color: Colors.black54,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, bottom: 15),
                                  child: Row(
                                    children: [
                                      Icon(Icons.mail, color: Colors.black54),
                                      Text(
                                        "  $useremail",
                                        style: GoogleFonts.lato(
                                          fontSize: 17,
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color:
                                                  Color.fromARGB(110, 0, 0, 0),
                                              width: 1))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            FirebaseAuth.instance.signOut();
                                          },
                                          child: Text(
                                            "Sign Out",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 212, 85, 76),
                                                fontSize: 20),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          transitionDuration: Duration(milliseconds: 150),
          barrierLabel: '',
          pageBuilder: (context, animation1, animation2) {
            return Text("page builder");
          });
    }

    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
                                    onPressed: () {
                                      notification();
                                    },
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
                                            color: Color.fromARGB(
                                                0, 244, 109, 109),
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
                                    onPressed: () {
                                      accountBox();
                                    },
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
                                              "${userName[0]}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 15, top: 15),
                                    child: CircularPercentIndicator(
                                      animation: true,
                                      animationDuration: 2000,
                                      radius: 90,
                                      lineWidth: 10,
                                      percent:
                                          (earningDetails['Parcentage']! / 100),
                                      progressColor:
                                          Color.fromARGB(255, 206, 137, 137),
                                      backgroundColor:
                                          Color.fromARGB(255, 219, 181, 181),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      center: Text(
                                        "${(earningDetails['Parcentage'])}%",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          "₹ ${earningDetails["MonthlyEarning"]}",
                                          style: GoogleFonts.lato(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  160, 0, 103, 38)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(
                                    left: 20, right: 19, top: 25),
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
                                          "₹ ${earningDetails["Due"]}",
                                          style: GoogleFonts.lato(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  137, 137, 0, 0)),
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
                                          "₹ ${earningDetails["ExpectedME"]}",
                                          style: GoogleFonts.lato(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  160, 1, 33, 122)),
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
                                          "₹ ${earningDetails["Total"]}",
                                          style: GoogleFonts.lato(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  160, 1, 33, 122)),
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
                              padding: EdgeInsets.only(
                                  bottom: 0, left: 20, right: 20),
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
                                                        BorderRadius.circular(
                                                            300)),
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
                                              color: Color.fromARGB(
                                                  221, 35, 34, 34)),
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
                                                        BorderRadius.circular(
                                                            300)),
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
                                              color: Color.fromARGB(
                                                  221, 35, 34, 34)),
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
                                                  builder:
                                                      (BuildContext context) =>
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
                                                        BorderRadius.circular(
                                                            300)),
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
                                              color: Color.fromARGB(
                                                  221, 35, 34, 34)),
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
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Student(
                                                    dueList: true,
                                                  ),
                                                ),
                                              );
                                              setState(() {
                                                load();
                                              });
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
                                                        BorderRadius.circular(
                                                            300)),
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
                                              color: Color.fromARGB(
                                                  221, 35, 34, 34)),
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
        ),
      ),
    );
  }
}
