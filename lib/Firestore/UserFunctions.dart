import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:omnus/Models/User.dart';

class UserFunctions {
  final Firestore _db = Firestore.instance;

  createFireStoreUser(String uid, String email, String firstName,
      String lastName, String phone, String zip) async {
    await _db.collection('users').document(uid).setData({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'zip': zip,
      'chefId' : ''
    });
  }

  Stream<DocumentSnapshot> getUserStreamByID(String id) {
    return _db.collection('users').document(id).snapshots();
  }

    Future<DocumentSnapshot> getUserByID(String id) async {
    return await _db.collection('users').document(id).get();
  }

  
  Stream<DocumentSnapshot> getChefStreamByID(String id) {
    return _db.collection('chefs').document(id).snapshots();
  }

  createChef(User user) async{
    DocumentReference ref;
    await _db.collection('chefs').add({
      'firstName' : user.firstName,
      'lastName' : user.lastName,
      'name' : user.name,
      'rate' : 0,
      'menu' : {},
      'zip' : user.zipcode
    }).then((result) => ref = result);

    await _db.collection('users').document(user.id).updateData({
      'chefId': ref.documentID
    });

  }
}

class UserStream {
  final Stream<DocumentSnapshot> stream;

  UserStream(this.stream);

}