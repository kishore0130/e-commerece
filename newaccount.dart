import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'crtl/login2.dart';

class newaccount extends StatefulWidget {
  const newaccount({super.key});

  @override
  State<newaccount> createState() => _newaccountState();
}

class _newaccountState extends State<newaccount> {
  bool show=false;
  final _key = GlobalKey<FormState>();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF11998e),
              Color(0xFF38ef7d),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                 SizedBox(height: 50),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_add_alt_1,
                    size: 45,
                    color: Color(0xFF11998e),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Create Account ✨",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Create your account to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                Card(
                  elevation: 10,
                  margin:  EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(20),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              prefixIcon:  Icon(Icons.email_outlined),
                              labelText: "Create your Mail ID",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (i) {
                              if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(i!)) {
                                return "Enter the valid mail id";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: password,
                            obscureText: !show,
                            decoration: InputDecoration(
                              prefixIcon:  Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    show = !show;
                                  });
                                },
                                icon: Icon(
                                  show
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              labelText: "Create your Password",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (i) {
                              if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~-]).{8,}$')
                                  .hasMatch(i!)) {
                                return "Enter the valid password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF11998e),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                login2.go2(
                                  context: context,
                                  email: email.text,
                                  password: password.text,
                                );
                              },
                              child:  Text(
                                "CREATE ACCOUNT",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:  Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF11998e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
