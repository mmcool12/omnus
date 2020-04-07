// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthConstants.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:provider/provider.dart';



class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  //@override

  //final AuthFunctions _auth = AuthFunctions();
  final _formKey = GlobalKey<FormState>();
  
  String _email;
  String _firstName;
  String _lastName;
  String _phone;
  String _zip;

  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    MediaQueryData queryData = MediaQuery.of(context);
    var ratio = queryData.devicePixelRatio;
    Map data = ModalRoute.of(context).settings.arguments;
    _email = data['email'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Personal Information',
                style: TextStyle(
                  color: Colors.yellow[800],
                  fontWeight: FontWeight.w600,
                  fontSize: ratio * 12
                ),
              ),
              Form(
                key: _formKey,
                autovalidate: true,
                onChanged: () => _formKey.currentState.save(),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                decoration: authInputDecorations.copyWith(hintText: 'First Name'),
                                textInputAction: TextInputAction.next,
                                validator: (value) => value.isEmpty ? 'First Name cannot be empty' : null,
                                onChanged: (value) => setState(() => _firstName = value.trim()),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: authInputDecorations.copyWith(hintText: 'Last Name'),
                              textInputAction: TextInputAction.next,
                              validator: (value) => value.isEmpty ? 'Last Name cannot be empty' : null,
                              onChanged: (value) => setState(() => _lastName = value.trim()),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: authInputDecorations.copyWith(hintText: 'Phone Number'),
                              textInputAction: TextInputAction.next,
                              validator: (value) => value.isEmpty ? 'Phone Number cannot be empty' : null,
                              onChanged: (value) => setState(() => _phone = value.trim()),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: authInputDecorations.copyWith(hintText: 'ZipCode'),
                              validator: (value) => value.isEmpty ? 'ZipCode cannot be empty' : null,
                              onChanged: (value) => setState(() => _zip = value.trim()),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.transparent,
                        child: SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            color: Colors.yellow[800],
                            splashColor: Colors.white70,
                            onPressed: () {
                              UserFunctions().createFireStoreUser(user.uid, _email, _firstName, _lastName, _phone, _zip);
                              Navigator.pop(context);
                              },
                            child: Text(
                              'Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
   
  }
}