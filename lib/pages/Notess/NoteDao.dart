import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NoteCumFolder {
  dynamic data;
  bool isNote = false;
  NoteCumFolder(this.data, this.isNote);
}

getClasses() async {
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

getAllNotesAndFolder(String path) async {
  ListResult result = await FirebaseStorage.instance.ref(path).listAll();
  List<NoteCumFolder> refList = [];

  //taking all folder
  result.prefixes.forEach((Reference ref) {
    print(ref.name);
    refList.add(NoteCumFolder(ref, false));
  });
  //taking all files
  result.items.forEach((Reference ref) {
    if (ref.fullPath.endsWith("pdf")) {
      refList.add(NoteCumFolder(ref, true));
    }
    print(ref.name);
  });

  return refList;
}

Future selectFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    // if (!isDispose) {
    //   setState(() => file = File(path));
    // }

    return File(path);
  } catch (e) {
    print(e);
  }
}

createEmptyFolder(String url) async {
  final ref = FirebaseStorage.instance.ref("$url/dev-trick");
  await ref.putString("dev-trick-biman");
}
