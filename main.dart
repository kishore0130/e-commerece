
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product/bottom.dart';
import 'package:product/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      ChangeNotifierProvider(
          create: (context)=>ThemProvider(),
          child:  const MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => qwer();
}
class qwer extends State<MyApp> {
  @override
  void initState() {
    Provider.of<ThemProvider>(context, listen: false).themeload();
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    var themedata= Provider.of<ThemProvider>(context);
    return MaterialApp(
      theme: themedata.black ? ThemeData.dark():ThemeData.light(),
      debugShowCheckedModeBanner: false,
        home: screen1(),
      );
  }
}
class ThemProvider extends ChangeNotifier {
  bool black = false ;
  theme({required bool darkmode})async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('repeat', black);
    black = darkmode;
    notifyListeners();
  }
  themeload()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   black= await prefs.getBool('repeat')!;
    notifyListeners();
  }

}
