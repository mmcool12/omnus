// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/BabyScreen.dart';
import 'package:omnus/MainScreens/LoadingScreen.dart';
import 'package:provider/provider.dart';


class AuthScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    
    if (user == null){
      return BabyScreen();
    } else{
      return LoadingScreen();
    }
   
  }

}