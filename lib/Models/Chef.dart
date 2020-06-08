import 'package:cloud_firestore/cloud_firestore.dart';

class Chef {
  String id;
  String firstName;
  String lastName;
  String name;
  String zip;
  String bio;
  List<dynamic> tags;
  List<dynamic> menu;
  String type;
  double rating;
  int numReviews;
  String mainImage;
  List<dynamic> images;
  bool active; 
  String profileImage;
  List<dynamic> reviews;
  List<dynamic> tokens;

  Chef({this.id, this.name, this.menu});

  Chef.fromMap(String id, Map<String, dynamic> map){
    this.id = id;
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.bio = map ['bio'];
    this.zip = map['zip'];
    this.menu = map['menu'];
    this.type = map['type'];
    this.rating = map['rating'].toDouble();
    this.reviews = map['reviews'];
    this.images = map['images'];
    this.tags = map['tags'];
    this.active = map['active'];
    this.profileImage = map['profileImage'];
    this.tokens = map['tokens'];
    this.numReviews = this.reviews.length;
    this.mainImage = this.images.isEmpty ? "" : this.images[0];
    this.name = this.firstName.trim() + ' ' + this.lastName.trim();
  }

  factory Chef.fromFirestore(DocumentSnapshot snapshot){
    return Chef.fromMap(snapshot.documentID,snapshot.data);
  }

}