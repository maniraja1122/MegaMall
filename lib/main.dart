import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megamall/Routes.dart';
import 'package:megamall/Screens/Home.dart';
import 'package:megamall/Screens/RegisterProcess/Login.dart';
import 'package:megamall/Screens/RegisterProcess/Selector.dart';
import 'package:megamall/Screens/RegisterProcess/SignUp.dart';

import 'Repository/DBHelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blue ,
          fontFamily: GoogleFonts.lato().fontFamily),
      darkTheme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.lato().fontFamily),
      initialRoute: DBHelper.auth.currentUser!=null?Routes.Home:Routes.Selector,
      routes: {
        Routes.Selector:(c)=>Selector(),
        Routes.Signup:(c)=>Signup(),
        Routes.Login:(c)=>Login(),
        Routes.Home:(c)=>HomePage()
      },
    );
  }
}
