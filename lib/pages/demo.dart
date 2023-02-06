import 'package:batch_manager/pages/home_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Demo extends StatelessWidget {
  CollectionReference users = FirebaseFirestore.instance.collection('Batches');
  var batchName = TextEditingController();
  var batchPrice = TextEditingController();
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'name': "${batchName.text}", // John Doe
          'price': batchPrice.text // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: batchName,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Batch name",
                          prefixIcon: Icon(
                            Icons.book,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) => {
                        print("Name ${batchName.text} Price ${batchPrice.text}")
                      },
                      controller: batchPrice,
                      decoration: InputDecoration(
                          hintText: "Price",
                          prefixIcon: Icon(
                            Icons.currency_rupee_sharp,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        onPressed: (() => {
                              addUser(),
                              print(
                                  "Name ${batchName.text} Price ${batchPrice.text}")
                            }),
                        child: Text("Create Batch"))
                  ]))),
    );
  }
}
