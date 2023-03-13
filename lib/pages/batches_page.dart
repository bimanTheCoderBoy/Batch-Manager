import 'package:batch_manager/main.dart';
import 'package:batch_manager/pages/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../firebase_options.dart';
import '../util/batch_Item.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

import '../util/student.dart';

// //batchList Items

// class BatchListItem extends StatefulWidget {
//   String name;
//   int price;
//   BatchListItem({super.key, required this.name, required this.price});
//   @override
//   State<BatchListItem> createState() => _BatchListItemState();
// }

// class _BatchListItemState extends State<BatchListItem> {
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       height: 100,
//       decoration: BoxDecoration(
//           color: Color.fromARGB(130, 148, 148, 148),
//           borderRadius: BorderRadius.circular(11),
//           border: Border.all(color: const Color(0xffA38762), width: 1)),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//               flex: 4,
//               child: Container(
//                   padding: EdgeInsets.only(left: 25),
//                   alignment: Alignment.center,
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerRight,
//                         padding: EdgeInsets.only(right: 6),
//                         height: 66,
//                         width: 134,
//                         decoration: const BoxDecoration(
//                             color: Color(0xFFD9D9D9),
//                             borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(11),
//                                 bottomRight: Radius.circular(11))),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Total Students",
//                               style: GoogleFonts.glory(
//                                 fontSize: 12,
//                               ),
//                             ),
//                             Text(
//                               "40",
//                               style: GoogleFonts.glassAntiqua(
//                                   color: Color(0xff156475),
//                                   fontSize: 23,
//                                   letterSpacing: -1),
//                             )
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                           left: -63,
//                           child: InnerShadow(
//                               shadows: [
//                                 Shadow(
//                                     color: Color.fromARGB(215, 251, 251, 251),
//                                     blurRadius: 5,
//                                     offset: Offset(0, 5))
//                               ],
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 height: 66,
//                                 width: 110,
//                                 decoration: BoxDecoration(
//                                     color: Color(0XffD5E1E4),
//                                     // boxShadow: [
//                                     //   BoxShadow(
//                                     //       color:
//                                     //           Color.fromARGB(100, 0, 0, 0),
//                                     //       blurRadius: 9,
//                                     //       spreadRadius: 1,
//                                     //       offset: Offset(0, 0))
//                                     // ],
//                                     borderRadius: BorderRadius.circular(500)),
//                                 child: Text(
//                                   widget.name,
//                                   style: GoogleFonts.handlee(
//                                     fontSize: 25,
//                                   ),
//                                 ),
//                               ))),
//                     ],
//                   ))),
//           Expanded(
//               flex: 1,
//               child: Icon(
//                 Icons.edit_note,
//                 size: 34,
//                 color: Color.fromARGB(199, 62, 61, 61),
//               ))
//         ],
//       ),
//     );
//   }
// }

class BatchList extends StatefulWidget {
  const BatchList({super.key});
  static String smallString(String n, {int number = 7}) {
    String nn = "";
    int i = 0;

    while (i < n.length) {
      nn += n[i];
      if (i == number) {
        nn += "..";
        break;
      }
      i++;
    }

    return nn;
  }

  @override
  State<BatchList> createState() => _BatchListState();
}

class _BatchListState extends State<BatchList> {
  var user;
  var batchName = TextEditingController();
  var batchPrice = TextEditingController();
  var batchClass = TextEditingController();
  List<bool> del = [];
  //addBatch
  CollectionReference? batch;
  loadBatch() {
    batch = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Batches');
  }

//-----------------------------------------------------------------------------

  List<StudentItem> studentItems = [];
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    var mapppedData = await records.docs.map((e) {
      return StudentItem.fromJson(e);
    }).toList();
    setState(() {
      studentItems = mapppedData;
    });
  }

  fetchRecordStu() async {
    var studentsFirebaseData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("student")
        .get();
    mapRecords(studentsFirebaseData);
  }

  stuCount({required String batch}) {
    int count = 0;
    for (var e in studentItems) {
      if (e.batch == batch) {
        count++;
      }
    }

    return count.toString();
  }

//--------------------------------------------------------------------------===
  Future<void> addBatch() {
    // Call the user's CollectionReference to add a new user
    return batch!
        .add({
          'name': "${batchName.text}", // John Doe
          'price':
              int.parse(batchPrice.text == "" ? "0" : batchPrice.text), // 42
          'class': batchClass.text
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//addBatch  end

//update data
  updateBatch(var batch) async {
    var batchOldName = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Batches')
        .doc(batch["id"])
        .get();
    for (var e in studentItems) {
      if (e.batch == await batchOldName.data()!["name"]) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("student")
            .doc(e.id)
            .update({"batch": batch["name"]});
      }
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Batches')
        .doc(batch['id'])
        .update({
      "name": batch['name'],
      "price": batch['price'],
      "class": batch['class']
    });
    setState(() {
      stuCount(batch: batch["name"]);
    });
  }

  deleteBatch(var id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("Batches")
        .doc(id)
        .delete();
  }

//update data end
  //*********************************************************************************** */
  CollectionReference? _batchListRef;

  late Stream<QuerySnapshot> _batchListRefStrem;
  //**********************************************************************************/
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    loadBatch();
    _batchListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Batches');
    _batchListRefStrem = _batchListRef!.snapshots();
    fetchRecordStu();
    super.initState();
  }

//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------
  head() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Color.fromARGB(0, 255, 193, 7),
            child: IconButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: Icon(Icons.arrow_back)),
          ),
          Text(
            "Batches Dashboard",
            style: GoogleFonts.hubballi(fontSize: 25),
          ),
          Material(
            color: Color.fromARGB(0, 255, 193, 7),
            child: IconButton(
                onPressed: () {
                  openDialogue(name: "Add Batch");
                },
                icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(137, 142, 141, 141),
                              blurRadius: 1)
                        ],
                        color: Color(0X70FEFDFC),
                        borderRadius: BorderRadius.circular(500)),
                    child: Icon(Icons.add))),
          ),
        ],
      ),
    );
  }

//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------
//dialogue functuon---------------------------------------------------------------
  openDialogue(
      {required String name,
      dynamic id,
      dynamic fees = "",
      dynamic batchname = "",
      dynamic clas = ""}) {
    setState(() {
      batchName.text = batchname;
      batchPrice.text = fees;
      batchClass.text = clas;
    });
    return showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
            scale: a1.value,
            child: Dialog(
              insetPadding: EdgeInsets.all(25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 255, 254, 252)),
                  child: Column(mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 136, 4, 243),
                                      width: 3))),
                          child: GradientText(
                            "$name",
                            style: GoogleFonts.hubballi(
                                fontWeight: FontWeight.bold, fontSize: 25),
                            colors: [
                              Color.fromARGB(255, 240, 160, 50),
                              Color.fromARGB(255, 34, 115, 255)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: batchName,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 4, 135, 243),
                                        width: 1.5)),
                                label: Text("title"),
                                // labelText: "hhh",
                                // hintText: batchname,
                                prefixIcon: Icon(
                                  Icons.book,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: batchClass,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 4, 135, 243),
                                        width: 1.5)),
                                label: Text("class"),
                                // labelText: "hhh",
                                // hintText: batchname,
                                prefixIcon: Icon(
                                  Icons.book,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) => {
                              if (name == "Add Batch")
                                {
                                  addBatch(),
                                }
                              else if (name == "Update Batch")
                                {
                                  updateBatch({
                                    "name": batchName.text,
                                    "price": int.parse(batchPrice.text),
                                    "class": batchClass.text,
                                    "id": id
                                  })
                                },
                              Navigator.pop(context),
                              batchName.clear(),
                              batchPrice.clear(),
                            },
                            controller: batchPrice,
                            decoration: InputDecoration(
                                label: Text("fees"),
                                // hintText: "$fees",
                                prefixIcon: Icon(
                                  Icons.currency_rupee_sharp,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    side: BorderSide(
                                        color:
                                            Color.fromARGB(255, 165, 165, 165),
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    )),
                                onPressed: (() => {
                                      batchName.clear(),
                                      batchPrice.clear(),
                                      Navigator.pop(context)
                                    }),
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
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    side: BorderSide(
                                        color:
                                            Color.fromARGB(255, 165, 165, 165),
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    )),
                                onPressed: (() => {
                                      if (batchName.text.trim().length > 15)
                                        {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "batch name should be with in 15 character!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 4,
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 93, 93),
                                              textColor: Color.fromARGB(
                                                  255, 226, 226, 226),
                                              fontSize: 13.0)
                                        }
                                      else if (name == "Add Batch")
                                        {
                                          addBatch(),
                                        }
                                      else if (name == "Update Batch")
                                        {
                                          updateBatch({
                                            "name": batchName.text,
                                            "price": int.parse(
                                                batchPrice.text == ""
                                                    ? "0"
                                                    : batchPrice.text),
                                            "class": batchClass.text,
                                            "id": id
                                          })
                                        },
                                      Navigator.pop(context),
                                      batchName.clear(),
                                      batchPrice.clear(),
                                    }),
                                child: GradientText(
                                  "Confirm",
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
                        )
                      ])),
            )),
        transitionDuration: Duration(milliseconds: 150),
        pageBuilder: (context, animation1, animation2) {
          return Text("page builder");
        });
  }

//-----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    dynamic classControll = "";
    return Material(
      // drawer: Drawer(),
      // appBar: AppBar(
      //   leading: Builder(
      //     builder: (context) => IconButton(
      //       icon: Icon(Icons.menu),
      //       onPressed: () => Scaffold.of(context).openDrawer(),
      //     ),
      //   ),
      //   shadowColor: Color(0xffDEC39E),
      //   foregroundColor: Color.fromARGB(255, 0, 0, 0),
      //   backgroundColor: Color(0xffDEC39E),
      //   elevation: 0,
      //   title: Text(
      //     "  Batches Dashboard",
      //     style: GoogleFonts.hubballi(fontSize: 25),
      //   ),
      // ),
      // drawer: Drawer(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffDEC39E), Color(0xffA4BED0)])),
        child: Column(
          children: [
            SafeArea(child: head()),
            Expanded(
                flex: 1,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _batchListRefStrem,
                  builder: ((BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      QuerySnapshot querySnapshot = snapshot.data;
                      List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                          querySnapshot.docs;

                      return listQueryDocumentSnapshot.length == 0
                          ? Center(
                              child: Text(
                                "No results found",
                                style: GoogleFonts.hubballi(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listQueryDocumentSnapshot.length,
                              itemBuilder: ((context, index) {
                                QueryDocumentSnapshot document =
                                    listQueryDocumentSnapshot[index];
                                del.add(false);

                                return Material(
                                  color: Color.fromARGB(0, 255, 193, 7),
                                  child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          del[index] = false;
                                        });
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Student(
                                                  dueList: false,
                                                  batch: document['name'])),
                                        );
                                        setState(() {
                                          fetchRecordStu();
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          del[index] = true;
                                        });
                                      },
                                      child: Stack(children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  130, 148, 148, 148),
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffA38762),
                                                  width: 1)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 6),
                                                            height: 66,
                                                            width: 134,
                                                            decoration: const BoxDecoration(
                                                                color: Color(
                                                                    0xFFD9D9D9),
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            11),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            11))),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Total Students",
                                                                  style:
                                                                      GoogleFonts
                                                                          .glory(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  stuCount(
                                                                      batch: document[
                                                                          'name']),
                                                                  style: GoogleFonts.hubballi(
                                                                      color: Color(
                                                                          0xff156475),
                                                                      fontSize:
                                                                          23,
                                                                      letterSpacing:
                                                                          -1),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                              left: -63,
                                                              child: InnerShadow(
                                                                  shadows: [
                                                                    Shadow(
                                                                        color: Color.fromARGB(
                                                                            215,
                                                                            251,
                                                                            251,
                                                                            251),
                                                                        blurRadius:
                                                                            5,
                                                                        offset: Offset(
                                                                            0,
                                                                            5))
                                                                  ],
                                                                  child: Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: 66,
                                                                    width: 110,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(0XffD5E1E4),
                                                                        // boxShadow: [
                                                                        //   BoxShadow(
                                                                        //       color:
                                                                        //           Color.fromARGB(100, 0, 0, 0),
                                                                        //       blurRadius: 9,
                                                                        //       spreadRadius: 1,
                                                                        //       offset: Offset(0, 0))
                                                                        // ],
                                                                        borderRadius: BorderRadius.circular(500)),
                                                                    child: Text(
                                                                      BatchList.smallString(
                                                                          document[
                                                                              'name']),
                                                                      style: GoogleFonts
                                                                          .handlee(
                                                                        fontSize:
                                                                            25,
                                                                      ),
                                                                    ),
                                                                  ))),
                                                        ],
                                                      ))),
                                              Expanded(
                                                  flex: 1,
                                                  child: Material(
                                                      color: Color.fromARGB(
                                                          0, 255, 193, 7),
                                                      child: InkWell(
                                                          splashColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  118,
                                                                  117,
                                                                  117),
                                                          splashFactory:
                                                              InkRipple
                                                                  .splashFactory,
                                                          onTap: () {
                                                            // updateBatch(
                                                            //   {
                                                            //   "id": document.id,
                                                            //   "name": "nnn",
                                                            //   "price": 10
                                                            // }),
                                                            try {
                                                              classControll =
                                                                  document[
                                                                      'class'];
                                                            } catch (e) {
                                                              classControll =
                                                                  "";
                                                            }
                                                            openDialogue(
                                                                name:
                                                                    "Update Batch",
                                                                id: document.id,
                                                                batchname:
                                                                    "${document["name"]}",
                                                                fees:
                                                                    "${document["price"]}",
                                                                clas:
                                                                    classControll);
                                                          },
                                                          child: Icon(
                                                            Icons.edit_note,
                                                            size: 34,
                                                            color:
                                                                Color.fromARGB(
                                                                    197,
                                                                    107,
                                                                    106,
                                                                    106),
                                                          ))))
                                            ],
                                          ),
                                        ),
                                        if (del[index])
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    183, 37, 37, 37),
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 252, 183, 34),
                                                    width: 2)),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                CircleBorder(),
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    175,
                                                                    49,
                                                                    48,
                                                                    48),
                                                            fixedSize:
                                                                Size(53, 53)),
                                                    onPressed: (() {
                                                      setState(() {
                                                        del[index] = false;
                                                      });
                                                    }),
                                                    child: Icon(Icons.close),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                CircleBorder(),
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    158,
                                                                    244,
                                                                    83,
                                                                    65),
                                                            fixedSize:
                                                                Size(53, 53)),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
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
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              20),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        "Are you sure, you want to delete ?",
                                                                        style: GoogleFonts.hubballi(
                                                                            fontSize:
                                                                                25,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              43,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Color.fromARGB(203, 145, 2, 2),
                                                                                side: BorderSide(color: Color.fromARGB(255, 32, 32, 32), width: 1.5),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(12), // <-- Radius
                                                                                )),
                                                                            onPressed:
                                                                                (() {
                                                                              deleteBatch(document.id);
                                                                              for (var element in studentItems) {
                                                                                if (element.batch == document['name']) {
                                                                                  FirebaseFirestore.instance.collection('users').doc(user.uid).collection("student").doc(element.id).delete();
                                                                                }
                                                                              }
                                                                              setState(() {
                                                                                del[index] = false;
                                                                              });
                                                                              Navigator.pop(context);
                                                                            }),
                                                                            child:
                                                                                Text(
                                                                              "Yes",
                                                                              style: GoogleFonts.hubballi(color: Color.fromARGB(221, 255, 255, 255), fontWeight: FontWeight.bold, fontSize: 25),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              43,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                                                                side: BorderSide(color: Color.fromARGB(255, 165, 165, 165), width: 1.5),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(12), // <-- Radius
                                                                                )),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "No",
                                                                              style: GoogleFonts.hubballi(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25),
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
                                                    child: Icon(Icons.delete),
                                                  ),
                                                ]),
                                          ),
                                      ])),
                                );
                              }));
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                )),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     openDialogue(name: "Add Batch");
      //   },
      //   backgroundColor: Color(0xff978EFF),
      //   foregroundColor: Colors.black,
      //   child: const Icon(
      //     Icons.add,
      //     size: 34,
      //   ),
      // ),
    );
  }
}
