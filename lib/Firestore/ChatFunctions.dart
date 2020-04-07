
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getChats(){
    return _db.collection('chat').getDocuments();
  }
}