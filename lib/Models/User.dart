
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnus/Models/Account.dart';

class User{

  final String uid;
  int numAccounts;
  bool verified;
  String publicToken;
  String accessToken;
  Map<String, Account> accounts;
  

  final CollectionReference userCollection = Firestore.instance.collection('users');

  User({this.uid}){
    this.numAccounts = 0;
    this.verified = false;
    this.publicToken = "";
    this.accessToken = "";
    this.accounts = {};
  }

  Account addAccount(Map<String, dynamic> account){
    Account newAccount = Account.fromMap(account);
    accounts[newAccount.id] =newAccount;
    return newAccount;
  }

  Future createFirebaseUser(String email, String firstName, String lastName, String phone, String zip) async {
    return await userCollection.document(this.uid).setData({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'zip': zip,
    });
  }
}

