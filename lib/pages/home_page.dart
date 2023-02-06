import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:themed/themed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_bot_flutter_mobile/whatsapp_bot_flutter_mobile.dart';
import 'package:whatsapp_sender_flutter/whatsapp_sender_flutter.dart';

import '../util/route.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromARGB(0, 255, 193, 7),
        child: Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                child: ClipRRect(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: ChangeColors(
                      brightness: 0,
                      child: Image.asset('assets/images/home_image1.png'),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(flex: 7, child: InkWell(child: HomeUp())),
                  Expanded(flex: 5, child: HomeBottom())
                ],
              )
            ],
          ),
        ));
  }
}

class HomeUp extends StatelessWidget {
  const HomeUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 7),
                child: Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.centerLeft,
                            children: [
                              Positioned(
                                  child: Image.asset(
                                      "assets/images/BatchText.png")),
                              Positioned(
                                  top: 32,
                                  left: 31,
                                  child: Image.asset(
                                      "assets/images/ManagerText.png")),
                            ])),
                    Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 10,
                                child: Image.asset(
                                    "assets/images/home_powerOff.png")),
                            Material(
                              color: Color.fromARGB(0, 255, 193, 7),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                splashColor: Color.fromARGB(68, 0, 0, 0),
                                splashFactory: InkRipple.splashFactory,
                                onTap: () {
                                  Navigator.pushNamed(context, Routte.batches);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                      child: Image.asset("assets/images/home_rectangle1.png")),
                  Positioned(
                      top: 7,
                      left: 40,
                      child: Text(
                        "User",
                        style: GoogleFonts.aldrich(fontSize: 18),
                      )),
                  Positioned(
                      top: 22,
                      left: 40,
                      child: Text(
                        "SANJOY SIR",
                        style: GoogleFonts.ibmPlexMono(fontSize: 18),
                      ))
                ],
              ),
            ),
          ],
        ));
  }
}

class HomeBottom extends StatelessWidget {
  const HomeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(child: Image.asset("assets/images/home_ellipse2.png")),
        Positioned(
            top: 5, child: Image.asset("assets/images/home_ellipse1.png")),
        Positioned(top: 50, child: HomePageButton())
      ],
    ));
  }
}

class HomePageButton extends StatelessWidget {
  const HomePageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
            // top: 500,

            child: Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routte.batches);
                    },
                    child: Image.asset("assets/images/home_spBottom.png")),
                Positioned(
                    left: 13,
                    top: 10,
                    child: Material(
                      color: Color.fromARGB(0, 255, 193, 7),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(500),
                        splashColor: Color.fromARGB(68, 0, 0, 0),
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {
                          // loadd();
                          FirebaseAuth.instance.signOut();
                          // await WhatsAppSenderFlutter.send(
                          //   phones: ["7076316977"],
                          //   message: "Test",
                          //   savedSessionDir: "0",
                          //   onEvent: (WhatsAppSenderFlutterStatus status) {
                          //     print(status);
                          //   },
                          //   onQrCode: (String qrCode) {
                          //     print(qrCode);
                          //   },
                          //   onSending: (WhatsAppSenderFlutterCounter counter) {
                          //     print(counter.toString());
                          //   },
                          //   onError: (WhatsAppSenderFlutterErrorMessage
                          //       errorMessage) {
                          //     print(errorMessage);
                          //   },
                          // );
                          // Navigator.pushNamed(context, Routte.batches);
                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ))
              ],
            )
          ],
        )),
        Positioned(
            // top: 70,

            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 65),
              // top: 70,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/images/home_button.png"),
                      Positioned(
                          child: Material(
                        color: Color.fromARGB(0, 255, 193, 7),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          splashColor: Color.fromARGB(68, 0, 0, 0),
                          splashFactory: InkRipple.splashFactory,
                          onTap: () {
                            Navigator.pushNamed(context, Routte.batches);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 120,
                            child: Text(
                              "Finance",
                              style: GoogleFonts.ibmPlexMono(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                    ],
                  )),
                  const SizedBox(
                    width: 50,
                  ),
                  Container(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/images/home_button.png"),
                      Positioned(
                          child: Material(
                        color: Color.fromARGB(0, 255, 193, 7),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          splashColor: Color.fromARGB(68, 0, 0, 0),
                          splashFactory: InkRipple.splashFactory,
                          onTap: () {
                            Navigator.pushNamed(context, Routte.batches);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 120,
                            child: Text(
                              "Collection",
                              style: GoogleFonts.ibmPlexMono(
                                  fontSize: 17, color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Container(
                // top: 170,
                child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/home_button.png"),
                    Positioned(
                        child: Material(
                      color: Color.fromARGB(0, 255, 193, 7),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        splashColor: Color.fromARGB(68, 0, 0, 0),
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {
                          Navigator.pushNamed(context, Routte.student);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 120,
                          child: Text(
                            "Students",
                            style: GoogleFonts.ibmPlexMono(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ))
                  ],
                )),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: [
                      Material(
                        color: Color.fromARGB(0, 255, 193, 7),
                        child: Image.asset("assets/images/home_button.png"),
                      ),
                      Positioned(
                          // top: 35,
                          child: Material(
                        color: Color.fromARGB(0, 255, 193, 7),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            splashColor: Color.fromARGB(68, 0, 0, 0),
                            splashFactory: InkRipple.splashFactory,
                            onTap: () {
                              Navigator.pushNamed(context, Routte.batches);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              width: 120,
                              child: Center(
                                child: Text(
                                  "Batches",
                                  style: GoogleFonts.ibmPlexMono(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )),
                      ))
                    ],
                  ),
                )
              ],
            ))
          ],
        ))
      ],
    ));
  }
}
