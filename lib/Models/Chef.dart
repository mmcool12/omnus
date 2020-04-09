import 'package:cloud_firestore/cloud_firestore.dart';

class Chef {
  String id;
  int rate;
  String firstName;
  String lastName;
  String name;
  String zip;
  Map menu;
  String type;
  double rating;
  int numReviews;
  String mainImage;

  Chef({this.id, this.rate, this.name, this.menu});

  Chef.fromMap(String id, Map<String, dynamic> map){
    this.id = id;
    this.rate = map['rate'];
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.name = this.firstName + ' ' + this.lastName;
    this.zip = map['zip'];
    this.menu = map['menu'];
    this.type = map['type'];
    this.rating = map['rating'].toDouble();
    this.numReviews = map['numReviews'];
    this.mainImage = map['mainImage'];
  }

  factory Chef.fromFirestore(DocumentSnapshot snapshot){
    return Chef.fromMap(snapshot.documentID,snapshot.data);
  }

}