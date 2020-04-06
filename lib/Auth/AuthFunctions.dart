import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/Models/User.dart';


class AuthFunctions with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _createUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_createUser);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(error) {
      print(error.toString());
      return null;
    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch(error) {
      print(error.toString());
      return null;
    }
  }

    Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _createUser(user);
    } catch(error) {
      print(error.toString());
      return null;
    }
  }
}