
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getChats(){
    return _db.collection('chat').getDocuments();
  }

  Stream<QuerySnapshot> getUsersChats(String id){
    return _db.collection('chat').where('buyerId', isEqualTo: id).snapshots();
  }

  Stream<DocumentSnapshot> getChatStream(String id){
    return _db.collection('chat').document(id).snapshots();
  }

  createChat(String docId, String senderId, String message) async {
    await _db.collection('chat').document(docId).updateData({
      'messages' : FieldValue.arrayUnion([
        {
          'message' : message,
          'sender' : senderId
        }
      ])},
    );
  }


}