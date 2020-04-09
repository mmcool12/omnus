import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
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
          backgroundColor: Colors.white,
          title: Text('Hello, Nobody', style: TextStyle(color: Colors.black),),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Profile', style: TextStyle(color: Colors.black),),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          actions: <Widget>[
            FlatButton(onPressed: () async {AuthFunctions().signOut();}, child: Text('Sign out'))
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 65,
                  ),
                  Container(
                    color: Colors.pink,
                    child: Column(
                      children: <Widget>[
                        Text(user.name)
                      ],
                    )
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1), bottom: BorderSide(width: 1)),
                color: Colors.white
              ),
              child: ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Payment Methods'),
                trailing: Icon(Icons.navigate_next),
              ),
            )
          ],
        ),
      );
    }
  }
}