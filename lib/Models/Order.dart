
import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String id;
  String buyerId;
  String buyerName;
  String buyerLocation;
  String chefId;
  String chefName;
  double price;
  bool accepted;
  bool rejected;
  bool completed;
  List<dynamic> meals;

  //bool get hasImage => this.image == "" ? false : true;

  Order.fromMap(String id, Map<dynamic, dynamic> map){
    this.id = id;
    this.buyerId = map['buyerId'];
    this.chefId = map['chefId'];
    this.buyerName = map['buyerName'];
    this.buyerLocation = map['buyerLocation'];
    this.chefName = map['chefName'];
    this.price = map['price'].toDouble();
    this.accepted = map['accepted'];
    this.rejected = map['rejected'];
    this.completed = map['completed'];
    this.meals = map['meals'];
  }

  factory Order.fromFirestore(DocumentSnapshot snapshot){
    return Order.fromMap(snapshot.documentID,snapshot.data);
  }
}