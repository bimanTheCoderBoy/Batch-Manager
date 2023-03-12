import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Note {
  static getClasses() async {
    var user = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Batches')
        .get()
        .then((value) {
      return value.docs
          .map((e) {
            dynamic res = "";
            try {
              res = e.data()["class"];
            } catch (e) {}
            return res;
          })
          .toSet()
          .toList();
    });
  }
}
