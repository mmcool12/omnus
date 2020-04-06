
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Models/Account.dart';

class User with ChangeNotifier{

  String id;
  String firstName;
  String lastName;
  String name;
  String zipcode;
  String chefId;

  String uid;
  int numAccounts;
  bool verified;
  String publicToken;
  String accessToken;
  Map<String, Account> accounts;
  


  User({this.uid}){
    this.numAccounts = 0;
    this.verified = false;
    this.publicToken = "";
    this.accessToken = "";
    this.accounts = {};
  }

  User.fromMap(String id, Map<String, dynamic> map){
    this.id = id;
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.name = this.firstName + ' ' + this.lastName;
    this.zipcode = map['zipcode'];
    this.chefId = map['chefId'];
  }

  factory User.fromFirestore(DocumentSnapshot snapshot){
    return User.fromMap(snapshot.documentID,snapshot.data);
  }

  void addAccount(Account account){
    this.accounts[account.id] = account;
  }

  }

