import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String time;
  String message;
  String sender; 

  Message();

  Message.fromMap(Map<dynamic,dynamic> data){
    this.time = data['time'];
    this.message = data['message'];
    this.sender = data['sender'];
  }

  // factory Message.fromFirestore(DocumentSnapshot snap){
  //   return Message.fromMap(snap.documentID, snap.data);
  // }
}