import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getAllChefs(){
    return _db.collection('chefs').getDocuments();
  }

  Future<DocumentSnapshot> getChefById(String id){
    return _db.collection('chefs').document(id).get();
  }

  // List<String> breakUpQuery(String query){
  //   if(query.length < 10){

  //   }
  // }

  Future<QuerySnapshot> getChefbyName(String query){
    return _db.collection('chefs').where('name', isGreaterThanOrEqualTo: query).getDocuments();
  }

  Future<QuerySnapshot> getChefbyType(String query){
      List<String> toSearch = [];
      query  = query.trim().toLowerCase();
      if (query.contains('chef')){
        toSearch.add('chef');
        toSearch.add('both');
      } else if (query.contains('prep')){
        toSearch.add('prep');
        toSearch.add('both');
      }
      return _db.collection('chefs').where('type', whereIn: toSearch).getDocuments();
  }

}
