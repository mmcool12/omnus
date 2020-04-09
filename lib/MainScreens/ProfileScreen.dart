import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user;

    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    if (user == null) {
      print(user.profileImage);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Loading',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  AuthFunctions().signOut();
                },
                child: Text('Sign out'))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async => ImageFunctions()
                                            .pickThenUploadProfile(
                                                ImageSource.camera, user.id),
                                        child: ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Image from Camera'),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          ImageFunctions()
                                              .pickThenUploadProfile(
                                                  ImageSource.gallery,
                                                  user.id);
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.photo_size_select_actual),
                                          title: Text('Image from Photos'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: FutureBuilder<dynamic>(
                          future:
                              ImageFunctions().getImage(user.profileImage),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==ConnectionState.done && snapshot.hasData) {
                              return GFAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 65,
                                backgroundImage: NetworkImage(
                                  snapshot.data ??
                                      'https://via.placeholder.com/150',
                                ),
                              );
                            } else {
                              return GFAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 65,
                                child: Text(
                                    user.firstName.substring(0, 1) +
                                        user.lastName.substring(0, 1),
                                    style: TextStyle(fontSize: 65)),
                              );
                            }
                          }),
                    ),
                    Expanded(
                      child: Container(
                          color: Colors.pink,
                          child: Column(
                            children: <Widget>[Text(user.name)],
                          )),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1),
                        bottom: BorderSide(width: 1)),
                    color: Colors.white),
                child: ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text('Payment Methods'),
                  trailing: Icon(Icons.navigate_next),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
