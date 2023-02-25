import 'package:batch_manager/main.dart';
import 'package:batch_manager/pages/forgot.dart';
import 'package:batch_manager/pages/register.dart';

import 'package:batch_manager/util/student_util.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../util/route.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  var _emailCon = TextEditingController();
  var _passCon = TextEditingController();

  signIn() async {
    showDialog(
        context: context,
        builder: ((context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailCon.text.trim(), password: _passCon.text.trim())
          .then((value) async {
        // await load();
        navgatorKey.currentState!.popUntil((route) => route.isFirst);
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 247, 109, 109),
          textColor: Color.fromARGB(255, 226, 226, 226),
          fontSize: 16.0);
      _emailCon.clear();
      _passCon.clear();
      navgatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    //     .then((value) {
    //   _emailCon.clear();
    //   _passCon.clear();
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => HomePage()));
    // }).catchError(() {
    //   _emailCon.clear();
    //   _passCon.clear();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 168),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: _emailCon,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            onSubmitted: (value) async {
                              await signIn();
                            },
                            controller: _passCon,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      await signIn();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const Register(),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const Forgot(),
                                      ),
                                    );
                                    // try {
                                    //   await FirebaseAuth.instance
                                    //       .sendPasswordResetEmail(
                                    //           email: _emailCon.text.trim());
                                    //   _emailCon.clear();
                                    //   Fluttertoast.showToast(
                                    //       msg: " Please Check Your Email ",
                                    //       toastLength: Toast.LENGTH_SHORT,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       timeInSecForIosWeb: 5,
                                    //       backgroundColor:
                                    //           Color.fromARGB(255, 1, 105, 48),
                                    //       textColor: Color.fromARGB(
                                    //           255, 255, 255, 255),
                                    //       fontSize: 16.0);
                                    // } catch (e) {
                                    //   Fluttertoast.showToast(
                                    //       msg:
                                    //           "  Type your Email Properly..  \n  For Resetting Password",
                                    //       toastLength: Toast.LENGTH_SHORT,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       timeInSecForIosWeb: 4,
                                    //       backgroundColor:
                                    //           Color.fromARGB(255, 165, 87, 87),
                                    //       textColor: Color.fromARGB(
                                    //           255, 255, 255, 255),
                                    //       fontSize: 16.0);
                                    //   _emailCon.clear();
                                    // }
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
