import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getReviewsByChefID(String chefId) async {
    return await _db.collection('reviews').where('chefId', isEqualTo: chefId).getDocuments();
  }

}