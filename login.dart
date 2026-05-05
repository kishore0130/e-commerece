import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bottom.dart';
import 'crtl/lodinCrtl.dart';
import 'newaccount.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool show=false;
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  final _key = GlobalKey<FormState>();

  Future<void> go()async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text
      );
      if(_key.currentState!.validate()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => bottom()));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login success")));
      }
    }catch(l)
    {
      if(_key.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$l")));
      }
    }
  }


  final GoogleSignIn  googleSignIn = GoogleSignIn(
      clientId: "1059997539785-343scc3kj44tj3378j6upf39eglujptj.apps.googleusercontent.com"
  );
  Future<User?> signInWithGoogle(BuildContext context) async
  {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      final user = userCredential.user;
      if (user != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context)=>bottom()),(route)
        {
          return false;
        });

      }
    } catch (e) {
      print(e);
    }
  }
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
                 SizedBox(height: 60),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 45,
                    color: Color(0xFF11998e),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Login to continue shopping",
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
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              prefixIcon:  Icon(Icons.email_outlined),
                              labelText: "Enter your Mail ID",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (i) {
                              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(i!)) {
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
                              labelText: "Enter your Password",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (i) {
                              if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~-]).{8,}$').hasMatch(i!)) {
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
                                LoginCtrl.go(
                                  context: context,
                                  password: password.text,
                                  email: email.text,
                                );
                              },
                              child:  Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              onPressed: () {
                                signInWithGoogle(context);
                              },
                              icon: Image.network(
                                "https://static.vecteezy.com/system/resources/previews/011/598/471/original/google-logo-icon-illustration-free-vector.jpg",
                                height: 25,
                              ),
                              label:  Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => newaccount(),
                                    ),
                                  );
                                },
                                child:  Text(
                                  "Create Account",
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
