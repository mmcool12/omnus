// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/SplashScreen.dart';
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
        ],
        child: SplashScreen(),
        );
  }
}
