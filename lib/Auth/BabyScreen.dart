// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:omnus/Auth/LoginScreen.dart';
import 'package:omnus/Auth/SignupScreen.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';


class BabyScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var ratio = queryData.devicePixelRatio;

    return WillPopScope(
      onWillPop: () => 
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('Do you really want to exit the app'),
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: ratio * 40,
                width: ratio * 40,
                child: FlutterLogo( colors: Colors.orange),
              ),
              Text(
                'Cirro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow[800],
                  fontWeight: FontWeight.bold,
                  fontSize: ratio * 12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: FlatButton(
                  onPressed: () => Navigator.pushNamed(context, '/Auth/Login'),
                  color: Colors.yellow[800],
                  splashColor: Colors.amber[50],
                  textColor: Colors.white,
                  child: Text(
                    'Log in',
                    style: TextStyle(fontSize: ratio*6),
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: FlatButton(
                  onPressed: () => Navigator.pushNamed(context, '/Auth/Signup'),
                  color: Colors.yellow[800],
                  splashColor: Colors.amber[50],
                  textColor: Colors.white,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: ratio*6),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
