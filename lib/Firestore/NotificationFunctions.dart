import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:omnus/Models/User.dart';

class NotificationFunctions {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging();


  Future<bool> checkToken() async {
    String token;
    token = await fcm.getToken();
    //print(token);
    return token != null;
  }

  Future<String> askPermission() async {
    bool hasToken = await checkToken();
    String token = "";
    if (!hasToken) {
      bool accepted = await fcm.requestNotificationPermissions(
        IosNotificationSettings()
      );
      if(accepted){
        token = await fcm.getToken();
      }
    }
    return token;
  }

  tokenCheck(String userId) async {
    //print('Token Check');
    String token = await askPermission();
    if(token != ""){
      print('Check DB');
      User user = User.fromFirestore( await _db.collection('users').document(userId).get());
      await saveToken(token, user);
    }
  }

  saveToken(String token, User user) async {
    //print('called');
    if(!user.tokens.contains(token)){
      await _db.collection('users').document(user.id).updateData({
        'tokens' : FieldValue.arrayUnion([token])
      });
      if (user.chefId != ""){
        await _db.collection('chefs').document(user.chefId).updateData({
          'tokens' : FieldValue.arrayUnion([token])
        });
      }
    }
  }

  saveNewToken(User user) async {
    String token = await fcm.getToken();
    if (token != "") {
      saveToken(token, user);
    }
  }

}