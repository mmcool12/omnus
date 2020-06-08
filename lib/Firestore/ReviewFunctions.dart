import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnus/Models/Order.dart';

class ReviewFunctions {
  final Firestore _db = Firestore.instance;

  Future<QuerySnapshot> getReviewsByChefID(String chefId) async {
    return await _db.collection('reviews').where('chefId', isEqualTo: chefId).getDocuments();
  }

  Future<void> createReview(Order order, String description, double rating, String title) async {
    // return await _db.collection('reviews').add({
    //   'buyerId' : order.buyerId,
    //   'buyerName' : order.buyerName,
    //   'chefId' : order.chefId,
    //   'description' : description,
    //   'rating' : rating,
    //   'title' : title
    // });
    return await _db.collection('chefs').document(order.chefId).updateData({
      'reviews' : FieldValue.arrayUnion([
        {
          'buyerId' : order.buyerId,
          'buyerName' : order.buyerName,
          'chefId' : order.chefId,
          'description' : description,
          'rating' : rating,
          'title' : title
        }
      ])
    });
  }

}