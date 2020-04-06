import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getAllChefs(){
    return _db.collection('chefs').getDocuments();
  }

}
