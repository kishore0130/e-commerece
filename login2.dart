import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import '../bottom.dart';




class login2{

  static Future<void> go2({required BuildContext context,required String email,required String password})async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => bottom()));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login success")));
    }catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e")));
    }
  }
}