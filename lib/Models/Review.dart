
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String chefId;
  String buyerId;
  String buyerName;
  String title;
  String description;
  int rating;

  Review();

  Review.fromMap(String id, Map<String,dynamic> data) {
    this.id = id;
    this.chefId = data['chefId'];
    this.buyerId = data['buyerId'];
    this.buyerName = data['buyerName'];
    this.title = data['title'];
    this.description = data['description'];
    this.rating = data['rating'];

  }

  factory Review.fromFirestore(DocumentSnapshot snap) {
    return Review.fromMap(snap.documentID, snap.data);
  }

  
}