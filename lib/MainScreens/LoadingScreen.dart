// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/MainScreens/AccountScreen.dart';
import 'package:omnus/MainScreens/ChefScreen.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Plaid/BankScreen.dart';
import 'package:provider/provider.dart';
import 'package:omnus/Models/User.dart';

class LoadingScreen extends StatefulWidget {
  final FirebaseUser fire;

  const LoadingScreen({
      Key key,
      @required this.fire
    }) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

User user;

class _LoadingScreenState extends State<LoadingScreen> {

  
  int currentIndex = 0;
  User user;
  
  @override
  void initState() {
    UserFunctions().getUserByID(widget.fire.uid).
      then((result) => user = User.fromFirestore(result));
  }

  void handleTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    

    final List<Widget> _children = [
      HomeScreen(),
      MultiProvider(
        providers: [
          StreamProvider<DocumentSnapshot>(create: (_) => UserFunctions().getChefStreamByID(user.chefId)),
          Provider<User>(create:(_) => user)
        ],
        child: ChefScreen(user: user),
      ),
      AccountScreen()
    ];

    return MultiProvider(
      providers: [
        StreamProvider<DocumentSnapshot>(create: (_) => UserFunctions().getUserStreamByID(widget.fire.uid)),
      ],
      child: Scaffold(
            body: _children[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                onTap: handleTap,
                currentIndex: currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fastfood),
                    title: Text('home'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.monetization_on),
                    title: Text('chef'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text('account'),
                  ),
                ])),
      );
  }
}
