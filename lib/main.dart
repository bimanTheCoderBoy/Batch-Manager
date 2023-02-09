// ignore_for_file: unrelated_type_equality_checks

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:batch_manager/pages/home_page.dart';
import 'package:batch_manager/pages/homepage.dart';
import 'package:batch_manager/pages/login.dart';
import 'package:batch_manager/pages/register.dart';
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
import 'package:page_transition/page_transition.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/batches_page.dart';
import 'package:flutter/services.dart';
import 'util/route.dart';

List<StudentItem> allStudent = [];
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
}

// scheduledTask.cancel();
// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
const fee = 'monthlyFees';
void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case fee:
        if (DateTime.now().day >= 1 && DateTime.now().day <= 10)
          await monthlyFees();
        break;
      default:
    }

    return Future.value(true);
  });
}

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
  await Workmanager().registerPeriodicTask('monthlyFees', 'monthlyFees',
      frequency: const Duration(days: 1),
      existingWorkPolicy: ExistingWorkPolicy.replace);

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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePagee();
          } else {
            return Login();
          }
        });
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        height: 600,
        color: Colors.amber,
      ),
      duration: 10000,
      nextScreen: Home(),
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: Color(0xffA4BED0),
    );
    ;
  }
}
//  LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [, Color(0xffA4BED0)])