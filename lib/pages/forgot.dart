import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../util/route.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCon.text.trim(), password: _passCon.text.trim());
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

    navgatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 70),
              child: Text(
                'Reset\nPassword',
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
                            onSubmitted: (value) async {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _emailCon.text.trim());
                                _emailCon.clear();
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: " Please Check Your Email ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor:
                                        Color.fromARGB(255, 1, 105, 48),
                                    textColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16.0);
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg:
                                        "  Type your Email Properly..  \n  For Resetting Password",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                    backgroundColor:
                                        Color.fromARGB(255, 165, 87, 87),
                                    textColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16.0);
                                _emailCon.clear();
                              }
                            },
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
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reset',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      // loadd();

                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: _emailCon.text.trim());
                                        _emailCon.clear();
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: " Please Check Your Email ",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 5,
                                            backgroundColor:
                                                Color.fromARGB(255, 1, 105, 48),
                                            textColor: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 16.0);
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "  Type your Email Properly..  \n  For Resetting Password",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                            backgroundColor: Color.fromARGB(
                                                255, 165, 87, 87),
                                            textColor: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 16.0);
                                        _emailCon.clear();
                                      }
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
