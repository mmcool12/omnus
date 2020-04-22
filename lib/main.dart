// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Auth/AuthScreen.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/SharedScreens/BabyScreen.dart';
import 'package:omnus/SharedScreens/LoginScreen.dart';
import 'package:omnus/SharedScreens/OnboardScreen.dart';
import 'package:omnus/SharedScreens/SignupScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0),
    // statusBarBrightness: Brightness.dark,
    // statusBarIconBrightness: Brightness.dark
  ));

  runApp(MyApp());  
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
              value: FirebaseAuth.instance.onAuthStateChanged),
              ChangeNotifierProvider(create: (context) => Cart())
        ],
        child: PlatformApp(
          debugShowCheckedModeBanner: false,
      home: AuthScreen(),
      android:(_) => MaterialAppData(
      theme: ThemeData(
        primaryColorDark: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          ),
        ),
      ),
      ios: (_) => CupertinoAppData(
        theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blueAccent,
          primaryContrastingColor: Colors.blue
        )
      ),
      routes: {
      '/Auth': (context) => BabyScreen(),
      '/Auth/Login': (context) => LoginScreen(),
      '/Auth/Signup': (context) => SignupScreen(),
      '/Auth/Onboard': (context) => OnboardScreen(),
      
    },
    ),
        );
  }
}
