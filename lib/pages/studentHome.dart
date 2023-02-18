import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StuHome extends StatefulWidget {
  const StuHome({super.key});

  @override
  State<StuHome> createState() => _StuHomeState();
}

class _StuHomeState extends State<StuHome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          icon: Text("bjjhvhvmnvbvnvnbvnvnv")),
    );
  }
}
