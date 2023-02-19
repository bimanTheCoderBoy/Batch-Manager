// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:batch_manager/pages/homepage.dart';
import 'package:batch_manager/pages/login.dart';
import 'package:batch_manager/pages/register.dart';
import 'package:batch_manager/pages/studentHome.dart';
import 'package:batch_manager/pages/student_page.dart';
import 'package:batch_manager/util/monthlyFee.dart';
import 'package:batch_manager/util/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

import 'pages/batches_page.dart';
import 'package:flutter/services.dart';
import 'util/route.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:batch_manager/util/noti.dart';

import 'util/student_util.dart';

List<StudentItem> allStudent = [];
List<String> mon = [
  "Janury",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
  var mapppedData = await records.docs.map((e) {
    return StudentItem.fromJson(e);
  }).toList();
  allStudent = mapppedData;

  return Future.value(true);
}

fetchRecord(var user) async {
  var studentsFirebaseData = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection("student")
      .get();

  return await mapRecords(studentsFirebaseData);
}

monthlyFees() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var user = await FirebaseAuth.instance.currentUser;
  print(
      "kkkkkkkkkkklllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllkkkkkkkkkkkkkkkkk");
  await fetchRecord(user);

  for (int i = 0; i < allStudent.length; i++) {
    print(allStudent[i].id);
    // var id = allStudent[i].id;
    List<MonthlyFee> account1 = allStudent[i].account;
    print(account1.length);
    List<Object> account = [];

    bool already = false;
    for (int i = 0; i < account1.length; i++) {
      if (account1[i].month == mon[DateTime.now().month - 1] &&
          account1[i].year == DateTime.now().year.toString()) already = true;

      account.add(account1[i].toJson());
    }

    late int price;
    var batchFirebaseData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("Batches")
        .get();
    var allBatch = await batchFirebaseData.docs.map((e) {
      return e.data();
    }).toList();
    if (!already) {
      allBatch.forEach((e) {
        print(e['name']);
        if (e['name'] == allStudent[i].batch) {
          price = e['price'];
        }
      });

      account.add({
        "month": mon[DateTime.now().month - 1],
        "year": DateTime.now().year.toString(),
        "isPaid": false,
        "paidDate": "",
        "dueMoney": price
      });
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('student')
        .doc(allStudent[i].id)
        .update({
      "name": allStudent[i].name,
      "number": allStudent[i].number,
      "batch": allStudent[i].batch,
      "balance":
          already ? allStudent[i].balance : allStudent[i].balance + price,
      "account": account
    });
  }
  MyNotification myNotification = MyNotification();
  await myNotification.initializeNotifications();
  await myNotification.sendNOtifications(
      'Data Update', "Student data updated successfuly");
  var notificationInstance =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  List notificationArray = [];
  notificationArray = notificationInstance.data()?["notifications"];
  var newNotification = {
    "body": "Student data updated successfuly",
    "date": DateTime.now().toLocal().toString().substring(0, 10),
    "time": "${DateTime.now().hour}:${DateTime.now().minute}"
  };
  notificationArray = [newNotification, ...notificationArray];
  // notificationArray.add(newNotification);
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update({'notifications': notificationArray});
}

earningUpdate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var user = FirebaseAuth.instance.currentUser;
  var earningInstance =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  List earningArray = [];
  earningArray = await earningInstance.data()?["monthlyEarningArray"];
  bool check = true;
  for (var e in earningArray) {
    if (e['time'] ==
        "${mon[DateTime.now().month - 1]} : ${DateTime.now().year}") {
      check = false;
      break;
    }
  }
  if (check) {
    var newMonth = {
      "due": (earningArray.isNotEmpty)
          ? (earningArray[0]["total"] - earningArray[0]["me"])
          : 0,
      "me": 0,
      "expectedMe": 0,
      "total": 0,
      "time": "${mon[DateTime.now().month]} : ${DateTime.now().year}"
    };
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      "monthlyEarningArray": [newMonth, ...earningArray]
    });
  }
}

const fee = 'monthlyFees';
const monthlyearning = 'monthlyearning';
void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case fee:
        if (DateTime.now().day <= 20) {
          await monthlyFees();
        }
        break;
      case monthlyearning:
        var month = DateTime.now().month;
        var day = DateTime.now().day;
        bool t27 = (month == 2);
        bool t31 = (month == 1 ||
            month == 3 ||
            month == 5 ||
            month == 7 ||
            month == 8 ||
            month == 10 ||
            month == 12);
        bool t30 = (!t27 && !t31);

        if ((day == 27 && t27) || (day == 31 && t31) || (day == 30 && t30)) {
          await earningUpdate();
        }
        break;
      default:
    }

    return Future.value(true);
  });
}

int isTeacher = 2;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  // await Workmanager().cancelAll();
  // await earningUpdate();

  // Periodic task registration
  // Workmanager().registerPeriodicTask(
  //   "1",
  //   "monthlyFees",
  //   // When no frequency is provided the default 15 minutes is set.
  //   // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  //   frequency: Duration(hours: 1),
  // );
  // Workmanager().cancelAll();
//------------------------------------------------------------------------------------------------------------

  // monthlyFees();

  runApp(MyApp());
}

final navgatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navgatorKey,
      title: 'Flutter Stateful Clicker Counter',
      theme: ThemeData(
        // Application theme data, you can set the colors for the application as
        // you want
        primarySwatch: Colors.blue,
      ),
      routes: {
        Routte.home: (context) => Splash(),
        Routte.batches: (context) => BatchList(),
        Routte.student: (context) => Student(
              dueList: true,
            ),
        Routte.register: (context) => Register(),
        Routte.login: (context) => Login()
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  load() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userInstance = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if ((userInstance.data() != null &&
          userInstance.data()!["isTeacher"] == true &&
          StuUtill.isStudent == true)) {
        FirebaseAuth.instance.signOut();
        return Future.error(Exception("error signing"));
      } else if ((userInstance.data() != null &&
          userInstance.data()!["isTeacher"] == true)) {
        setState(() {
          isTeacher = 1;
          StuUtill.isStudent = 0;
        });
      } else {
        setState(() {
          isTeacher = 0;
          StuUtill.isStudent = 1;
        });
      }
    }

    if (isTeacher == 1 && StuUtill.isStudent == 0) {
      await Workmanager().registerPeriodicTask('monthlyFees', 'monthlyFees',
          frequency: const Duration(days: 1),
          existingWorkPolicy: ExistingWorkPolicy.replace);
      await Workmanager().registerPeriodicTask(monthlyearning, monthlyearning,
          frequency: const Duration(days: 1),
          existingWorkPolicy: ExistingWorkPolicy.replace);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // FirebaseAuth.instance.signOut();

          if (snapshot.hasData) {
            return (isTeacher == 2 || StuUtill.isStudent == 2)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : (isTeacher == 1 && StuUtill.isStudent == 0)
                    ? HomePagee()
                    : StuHome();
          } else {
            return CheckStudentTeacher();
          }
        });
  }
}

class CheckStudentTeacher extends StatelessWidget {
  const CheckStudentTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
      child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SafeArea(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Are you a teacher or a student ?",
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          splashColor: Colors.black12,
                          highlightColor: Colors.black12,
                          iconSize: 100,
                          onPressed: () {
                            isTeacher = 1;
                            StuUtill.isStudent = 0;
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const Login(),
                              ),
                            );
                          },
                          icon: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10000),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 13,
                                      spreadRadius: 7)
                                ]),
                            child: Image.asset(
                              "assets/images/teacherIcon.png",
                              height: 100,
                            ),
                          ),
                        ),
                        Center(
                          child: Text("Teacher"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        IconButton(
                          splashColor: Colors.black12,
                          highlightColor: Colors.black12,
                          iconSize: 100,
                          onPressed: () {
                            StuUtill.isStudent = 1;
                            isTeacher = 0;
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const Login(),
                              ),
                            );
                          },
                          icon: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10000),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 13,
                                      spreadRadius: 7)
                                ]),
                            child: Image.asset(
                              "assets/images/stuIcon.png",
                            ),
                          ),
                        ),
                        Center(
                          child: Text("Student"),
                        )
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(143, 243, 117, 117), width: 1),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Container(
          height: 84.5,
          width: 81,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 20, spreadRadius: 2),
              ]),
          child: Image.asset(
            "assets/images/logo.jpg",
            scale: 3,
            fit: BoxFit.none,
          ),
        ),
      ),
      duration: 1000,
      nextScreen: Home(),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: Color.fromARGB(192, 179, 203, 222),
    );
    ;
  }
}
//  LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [, Color(0xffA4BED0)])