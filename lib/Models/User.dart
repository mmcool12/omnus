
import 'package:cloud_firestore/cloud_firestore.dart';


class User {

  String id;
  String firstName;
  String lastName;
  String name;
  String zipcode;
  String chefId;
  String profileImage;
  List<dynamic> tokens;
  


  User({this.id});

  User.fromMap(String id, Map<String, dynamic> map){
    this.id = id;
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.name = this.firstName + ' ' + this.lastName;
    this.zipcode = map['zip'];
    this.chefId = map['chefId'];
    this.profileImage = map['profileImage'];
    this.tokens = map['tokens'];
  }

  factory User.fromFirestore(DocumentSnapshot snapshot){
    return User.fromMap(snapshot.documentID,snapshot.data);
  }

  }

