// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthConstants.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Auth/AuthLoading.dart';
import 'package:provider/provider.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthFunctions _auth = AuthFunctions();
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool loading = false;

  fireSignin () async {
    _formKey.currentState.save();
    if(_formKey.currentState.validate()){
      setState(() => loading = true);
      dynamic result = await _auth.signIn(_email, _password);
      if(result == null){
        setState(() => loading = false);
        print('error');
      } else {
        setState(() => loading = false);
          Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }
  }
  
  Widget build(BuildContext context) {
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    MediaQueryData queryData = MediaQuery.of(context);
    var ratio = queryData.devicePixelRatio;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Sign in',
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
                      TextFormField(
                        decoration: authInputDecorations.copyWith(hintText: 'Email'),
                        textInputAction: TextInputAction.next,
                        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
                        onChanged: (value) => setState(() => _email = value),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      TextFormField(
                        decoration: authInputDecorations.copyWith(hintText: 'Password'),
                        validator: (value) => value.isEmpty ? 'password cannot be empty' : null,
                        onChanged: (value) => setState(() => _password = value),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () => print('password: $_password'),
                          child: Text(
                            'forgot password',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.yellow[800]
                            ),
                          ),
                        ),
                      ),
                      (loading ? 
                        Padding(padding: EdgeInsets.only(bottom: 15), child: AuthLoading()) 
                        : Padding(padding: EdgeInsets.all(0),)
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.transparent,
                        child: SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            color: Colors.yellow[800],
                            splashColor: Colors.white70,
                            onPressed: () async { fireSignin();},
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/Auth/Signup'),
                          child: Text(
                            'Don''t have an account? Sign up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow[800]
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
