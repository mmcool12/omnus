
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  String chefId;
  String buyerId;
  String chefName;
  String buyerName;
  List<dynamic> messages;

  Chat();

  Chat.fromMap(String id, Map<String,dynamic> data) {
    this.id = id;
    this.chefId = data['chefId'];
    this.buyerId = data['buyerId'];
    this.chefName = data['chefName'];
    this.buyerName = data['buyerName'];
    this.messages = data['messages'];

  }

  factory Chat.fromFirestore(DocumentSnapshot snap) {
    return Chat.fromMap(snap.documentID, snap.data);
  }

  
}