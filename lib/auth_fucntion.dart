import 'package:card/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  static signUpUser(
    String name,
    String uname,
    String email,
    String password,
    String avatar,
    DateTime startDate,
    BuildContext buildContext,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(uname);
      await userCredential.user!.updatePhotoURL(avatar);
      String uid = userCredential.user!.uid;
      Players user = Players(
          playerID: uid,
          yourName: name,
          userName: uname,
          email: email,
          avatar: avatar,
          startDate: startDate);
      DocumentReference doc =
          FirebaseFirestore.instance.collection("Users").doc(uid);
      await doc
          .set(user.toMap())
          .whenComplete(() => showDialog(
              context: buildContext,
              builder: (context) {
                return DialogOverlay(
                  isSuccess: true,
                  task: 'Create User',
                );
              }))
          .whenComplete(() => Navigator.of(buildContext).pop());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(buildContext).showSnackBar(
            SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(buildContext).showSnackBar(
            SnackBar(content: Text('Email Provided already Exists')));
      } else {
        ScaffoldMessenger.of(buildContext)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }
  }
}

class DialogOverlay extends StatelessWidget {
  final bool isSuccess;
  final String task;
  final String? error;

  const DialogOverlay(
      {super.key, required this.isSuccess, required this.task, this.error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0),
      shadowColor: Colors.white.withOpacity(0),
      content: Text(
        isSuccess ? '$task Successed!' : '$task Failed!\n${error ?? ''}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
