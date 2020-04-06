import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User user;

    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }
    
    if(user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Hello, Nobody'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
      );
    }
  }
}