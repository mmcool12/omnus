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
  int currentIndex = 0;
  Widget currentScreen;
  PlatformTabController tabController;
  @override
  void initState() {
    tabController = PlatformTabController(initialIndex: 0);
    super.initState();
  }

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
      child: PlatformTabScaffold(
          bodyBuilder: (BuildContext context, int index) {
            return _children[index];
          },
          tabController: tabController,
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
                      CupertinoIcons.search,
                      size: 35,
                    ),
                    android: (_) => Icon(Icons.search),
                  ),
                  title: Text('search'),
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
                if(false)
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
          ),
    );
  }
}
