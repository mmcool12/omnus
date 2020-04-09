import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getAllChefs() async {
    return await _db.collection('chefs').limit(20).getDocuments();
  }

  Future<DocumentSnapshot> getChefById(String id) async {
    return await _db.collection('chefs').document(id).get();
  }

  // List<String> breakUpQuery(String query){
  //   if(query.length < 10){

  //   }
  // }

  Future<QuerySnapshot> getChefbyName(String query) async {
    return await _db.collection('chefs').where('name', isGreaterThanOrEqualTo: query).getDocuments();
  }

  Future<QuerySnapshot> getChefbyType(String query) async {
      List<String> toSearch = [];
      query  = query.trim().toLowerCase();
      if (query.contains('chef')){
        toSearch.add('chef');
        toSearch.add('both');
      } else if (query.contains('prep')){
        toSearch.add('prep');
        toSearch.add('both');
      }
      return await _db.collection('chefs').where('type', whereIn: toSearch).getDocuments();
  }

}
