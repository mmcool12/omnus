// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthConstants.dart';
import 'package:omnus/Auth/AuthLoading.dart';
import 'package:omnus/Auth/AuthScreen.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Auth/LoginScreen.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  final AuthFunctions _auth = AuthFunctions();
  
  FocusNode passwordfocus;   
  String _password;  
  String _email; 
  bool loading = false;

    @override
  void initState() {
    super.initState();
    passwordfocus = FocusNode();
  }
  

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    passwordfocus.dispose();

    super.dispose();
  }

  Future<void> attemptSignUp(email, password, first, last, number, zip, context) async {
    _formKey.currentState.save();
    if(_formKey.currentState.validate()){
      setState(() => loading = true);
      if(await AuthFunctions().cognitoSignIn(email, password, first, last, number, zip)){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        _formKey.currentState.validate();
      }
    }
  }

  fireSignup () async {
    _formKey.currentState.save();
    if(_formKey.currentState.validate()){
      setState(() => loading = true);
      dynamic result = await _auth.signUp(_email.trim(), _password.trim());
      if(result == null){
        setState(() => loading = false);
        print('error');
      } else {
        setState(() => loading = false);
        Navigator.pushNamedAndRemoveUntil(context, '/Plaid/Onboard', ModalRoute.withName('/') ,arguments: {'email': _email});
      }
    }
  }
  
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var ratio = queryData.devicePixelRatio;

    return WillPopScope(
      onWillPop: () => Navigator.push(context, MaterialPageRoute( builder: (context) => BabyScreen())),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Create Account',
                  style: TextStyle(
                    color: Colors.yellow[800],
                    fontWeight: FontWeight.w600,
                    fontSize: ratio * 12
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidate: false,
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
                          onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(passwordfocus),
                          validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
                          onChanged: (value) => setState(() => _email = value),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        TextFormField(
                          decoration: authInputDecorations.copyWith(hintText: 'Password'),
                          focusNode: passwordfocus,
                          onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(new FocusNode()),
                          validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
                          onChanged: (value) => setState(() => _password = value),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        (loading ? 
                          Padding(padding: EdgeInsets.only(bottom: 16), child: AuthLoading()) 
                          : Padding(padding: EdgeInsets.all(0))
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          color: Colors.transparent,
                          child: SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              color: Colors.yellow[800],
                              splashColor: Colors.white70,
                              onPressed: () => fireSignup(),
                              child: Text(
                                'Sign up',
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
                            color: Colors.white,
                            onPressed: () => Navigator.pushReplacementNamed(context, '/Auth/Login'),
                            child: Text(
                              'Already have an account? Sign in',
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
      ),
    );
  }
}
