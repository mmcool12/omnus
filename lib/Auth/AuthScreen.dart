// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/MainScreens/LoadingScreen.dart';
import 'package:provider/provider.dart';


class AuthScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    
    if (user == null){
      return BabyScreen();
    } else{
      return MultiProvider(
        providers: [
          StreamProvider<DocumentSnapshot>(create: (_) => UserFunctions().getUserStreamByID(user.uid)),
        ],
        child: LoadingScreen()
      );
    }
   
  }

}


  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.yellow[800],
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Placeholder(
  //             color: Colors.white,
  //             fallbackHeight: 100,
  //             fallbackWidth: 100,
  //           ),
  //           Text(
  //             'Cirro',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 25
  //             ),
  //           ),
  //           FlatButton(
  //             onPressed: () {
  //               Navigator.push(
  //               context, 
  //               MaterialPageRoute(builder: (context) => BabyScreen()),
  //               );
  //             },
  //             color: Colors.blue,
  //             textColor: Colors.white,
  //             padding: EdgeInsets.all(10),
  //             child: Text(
  //               'Skip',
  //               ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }