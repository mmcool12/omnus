// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:omnus/MainScreens/AccountScreen.dart';
import 'package:omnus/MainScreens/ChatScreen.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Models/User.dart';

class LoadingScreen extends StatefulWidget {
  //final FirebaseUser fire;

  // const LoadingScreen({
  //     Key key,
  //     @required this.fire
  //   }) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

//User user;

class _LoadingScreenState extends State<LoadingScreen> {

  
  int currentIndex = 1;
  User user;

  void handleTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    

    final List<Widget> _children = [
      AccountScreen(),
      HomeScreen(),
      ChatScreen(),
    ];

    return Scaffold(
          body: _children[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              onTap: handleTap,
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('account'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood),
                  title: Text('home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  title: Text('messages'),
                ),
              ]));
  }
}
