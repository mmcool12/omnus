import 'package:cloud_firestore/cloud_firestore.dart';

class Chef {
  String id;
  int rate;
  String firstName;
  String lastName;
  String name;
  String zip;
  Map menu;

  Chef({this.id, this.rate, this.name, this.menu});

  Chef.fromMap(String id, Map<String, dynamic> map){
    this.id = id;
    this.rate = map['rate'];
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.name = this.firstName + ' ' + this.lastName;
    this.zip = map['zip'];
    this.menu = map['menu'];
  }

  factory Chef.fromFirestore(DocumentSnapshot snapshot){
    return Chef.fromMap(snapshot.documentID,snapshot.data);
  }

}