import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';

class NotificationFunctions {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging();


  Future<bool> checkToken() async {
    String token;
    token = await fcm.getToken();
    print(token);
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
    print('Hello');
    String token = await askPermission();
    if(token != ""){
      User user = User.fromFirestore( await _db.collection('users').document(userId).get());
      await saveToken(token, user);
    }
  }

  saveToken(String token, User user) async {
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

}