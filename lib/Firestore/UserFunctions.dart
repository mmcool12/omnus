import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFunctions {
  final Firestore _db = Firestore.instance;

  createFireStoreUser(String uid, String email, String firstName,
      String lastName, String phone, String zip) async {
    await _db.collection('users').document(uid).setData({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'zipcode': zip,
      'chefId' : '',
      'profileImage' : ''
    });
  }

  Stream<DocumentSnapshot> getUserStreamByID(String id) {
    if(id == null) return null;
    return _db.collection('users').document(id).snapshots();
  }

  // Future<Stream<User>> getUserStream(String id) {
  //   Stream<DocumentSnapshot> stream = _db.collection('users').document(id).snapshots();
  //   return stream.forEach((snapshot) => User.fromFirestore(snapshot));
  // }

    Future<DocumentSnapshot> getUserByID(String id) async {
    return await _db.collection('users').document(id).get();
  }

  
  Stream<DocumentSnapshot> getChefStreamByID(String id) {
    return _db.collection('chefs').document(id).snapshots();
  }

  Future<QuerySnapshot> getAllChefs() async{
    return await _db.collection('chefs').limit(20).getDocuments();
  }

  Future<QuerySnapshot> getOrdersById(String id) async {
    return await _db.collection('orders').where('buyerId', isEqualTo: id).getDocuments();
  }

}
