// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Auth/AuthScreen.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/Auth/LoginScreen.dart';
import 'package:omnus/Auth/SignupScreen.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/Plaid/BankScreen.dart';
import 'package:omnus/Plaid/OnboardScreen.dart';
import 'package:omnus/Plaid/LoadingScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthFunctions().user,
      child: MaterialApp(
        home: AuthScreen(),
        routes: {
          '/Auth': (context) => BabyScreen(),
          '/Auth/Login': (context) => LoginScreen(),
          '/Auth/Signup': (context) => SignupScreen(),
          '/Plaid/Onboard': (context) => OnboardScreen(),
          '/Plaid/Bank': (context) => BankScreen(),
          '/Home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
