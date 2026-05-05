import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../bottom.dart';

class LoginCtrl {

  static Future<void> go({
    required BuildContext context,
    required String email,
    required String password,
  }) async {

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => bottom()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login success")),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }
  }
}