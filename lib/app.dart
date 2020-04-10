import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthScreen.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/SharedScreens/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:omnus/SharedScreens/HomeScreen.dart';
import 'package:omnus/SharedScreens/LoadingScreen.dart';
import 'package:omnus/SharedScreens/SignupScreen.dart';
import 'package:omnus/SharedScreens/OnboardScreen.dart';
import 'package:omnus/SharedScreens/BabyScreen.dart';
// import 'package:omnus/Auth/LoginScreen.dart';
//import 'package:omnus/Auth/SignupScreen.dart';

class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    FirebaseUser fire = Provider.of<FirebaseUser>(context);

    return MaterialApp(
      home: AuthScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          ),
        ),
      routes: {
      '/Auth': (context) => BabyScreen(),
      '/Auth/Login': (context) => LoginScreen(),
      '/Auth/Signup': (context) => SignupScreen(),
      '/Auth/Onboard': (context) => OnboardScreen(),
      '/Home': (context) => HomeScreen(),
      '/Loading': (context) => LoadingScreen(),
      
    },
    );
  }
}
