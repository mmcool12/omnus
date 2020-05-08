// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/SharedScreens/ChatScreen.dart';
import 'package:omnus/SharedScreens/HomeScreen.dart';
import 'package:omnus/SharedScreens/ProfileScreen.dart';
import 'package:omnus/SharedScreens/SearchScreen.dart';

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
  Widget currentScreen;

  void handleTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> _children = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Do you really want to exit the app'),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => exit(0),
                    child: Text('Yes'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('No'),
                  ),
                ],
              ),
            ]),
      ),
      child: PlatformScaffold(
          body: IndexedStack(
            //key: Key('$currentIndex'),
            index: currentIndex,
            children: _children,
          ),
          bottomNavBar: PlatformNavBar(
            backgroundColor: Colors.white,
              itemChanged: handleTap,
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: PlatformWidget(
                    ios: (_) => Icon(
                      Icons.lightbulb_outline,
                      size: 35,
                    ),
                    android: (_) => Icon(Icons.lightbulb_outline),
                  ),
                  title: Text('discover'),
                ),
                BottomNavigationBarItem(
                  icon: PlatformWidget(
                    ios: (_) => Icon(
                      CupertinoIcons.conversation_bubble,
                      size: 35,
                    ),
                    android: (_) => Icon(Icons.message),
                  ),
                  title: Text('messages'),
                ),
                BottomNavigationBarItem(
                  icon: PlatformWidget(
                    ios: (_) => Icon(
                      CupertinoIcons.profile_circled,
                      size: 35,
                    ),
                    android: (_) => Icon(Icons.person),
                  ),
                  title: Text('account'),
                ),
              ],
              ios: (_) => CupertinoTabBarData(
                iconSize: 10,
                backgroundColor: Colors.white,
                ),
          )
          ),
    );
  }
}
