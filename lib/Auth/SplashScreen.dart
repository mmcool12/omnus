import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthScreen.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:provider/provider.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/MainScreens/LoadingScreen.dart';
import 'package:omnus/Plaid/OnboardScreen.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/Auth/LoginScreen.dart';
import 'package:omnus/Auth/SignupScreen.dart';

class SplashScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    FirebaseUser fire = Provider.of<FirebaseUser>(context);

    return MultiProvider(
        providers: [
          StreamProvider<DocumentSnapshot>(
              create:(_) => UserFunctions().getUserStreamByID(fire.uid)),
        ],
        child: MaterialApp(
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
          '/Plaid/Onboard': (context) => OnboardScreen(),
          '/Home': (context) => HomeScreen(),
          '/Loading': (context) => LoadingScreen(),
        },
        ),
        );
  }
}
