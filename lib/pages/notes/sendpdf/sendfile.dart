import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class SendFile extends StatefulWidget {
  const SendFile({super.key});

  @override
  State<SendFile> createState() => _SendFileState();
}

class _SendFileState extends State<SendFile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(182, 73, 134, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Choose Pdf",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Text(
                      "Choose Class",
                      style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(182, 73, 134, 255)),
                    ),
                  ],
                ),
                Container(
                  height: 270,
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color.fromARGB(182, 73, 134, 255),
                          width: 2)),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(182, 73, 134, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Upload Pdf",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
