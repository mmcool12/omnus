
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:rxdart/rxdart.dart';

class ChatFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getChats() async {
    return await _db.collection('chat').getDocuments();
  }

  Stream<QuerySnapshot> getUsersChats(String id){
    return _db.collection('chat').where('buyerId', isEqualTo: id).snapshots();
  }

  Stream<QuerySnapshot> getChefsChats(String id){
    return _db.collection('chat').where('chefId', isEqualTo: id).snapshots();
  }

  Stream<DocumentSnapshot> getChatStream(String id){
    return _db.collection('chat').document(id).snapshots();
  }

  createMessage(String docId, String senderId, String message) async {
    await _db.collection('chat').document(docId).updateData({
      'messages' : FieldValue.arrayUnion([
        {
          'message' : message,
          'sender' : senderId
        }
      ])},
    );
  }

  Future<DocumentSnapshot> createChat(User buyer, Chef chef) async {
    // First check if chat exists
    QuerySnapshot snapshot;
    await _db.collection('chat').where('buyerId', isEqualTo: buyer.id).where('chefId', isEqualTo: chef.id).getDocuments()
      .then((result) => snapshot = result);
      
    if (snapshot.documents.isEmpty){
      DocumentReference ref =  await _db.collection('chat').add({
        'buyerId' : buyer.id,
        'buyerName' : buyer.name,
        'chefId' : chef.id,
        'chefName' : chef.name,
        'messages' : []
      });
      return ref.get();
    } else {
      return snapshot.documents[0];
    }

  }


}