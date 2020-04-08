// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthScreen.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/Auth/LoginScreen.dart';
import 'package:omnus/Auth/SignupScreen.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Plaid/OnboardScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged
        ),
      ],
          child: MaterialApp(
        home: AuthScreen(),
        routes: {
          '/Auth': (context) => BabyScreen(),
          '/Auth/Login': (context) => LoginScreen(),
          '/Auth/Signup': (context) => SignupScreen(),
          '/Plaid/Onboard': (context) => OnboardScreen(),
          '/Home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
