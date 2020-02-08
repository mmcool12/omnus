// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Plaid/BankScreen.dart';
import 'package:omnus/Plaid/LoadingScreen.dart';
import 'package:provider/provider.dart';
import 'package:omnus/Models/User.dart';


class AuthScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final AuthFunctions _auth = AuthFunctions();
    final user = Provider.of<User>(context);
    print(user.accounts);

    return StreamBuilder(
      stream: _auth.user,
      builder: (context, AsyncSnapshot<User> snapshot){
        print(snapshot.data);
        if(snapshot.data == null){
          return BabyScreen();
        } else {
          return HomeScreen();
        }
      },
    );
   
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