
import 'package:omnus/Database/DataModels.dart';

class Account{
  String accessKey;
  String publicKey;
  String itemId;
  String id;
  String type;
  String subtype; 
  Map<String,dynamic> balance;
  Map<String,dynamic> meta;

  String currency;
  String name;
  String number;
  double availBalance;
  double curBalance;


  Account({this.id, this.type, this.subtype, this.balance, this.meta}){
    this.publicKey = 'null';
    this.name = this.meta['name'];
    this.number = this.meta['number'];
    this.availBalance = this.balance['available'];
    this.curBalance = this.balance['current'];
    this.currency = 'null';
  }

  Account.fromStored(StoredAccount stored) {
    this.number = stored.number;
    this.publicKey = stored.publicKey;
    this.accessKey = stored.accessKey;
    this.itemId = stored.itemId;
    this.name = stored.name;
    this.type = stored.type;
    this.availBalance = stored.availableBalance as double;
    this.curBalance = stored.currentBalance as double;
  }

  Account.fromMap(Map<String, dynamic> data, this.accessKey, this.itemId){
    this.id = data['id'];
    this.type = data['type'];
    this.subtype = data['subtype'];
    this.meta = data['meta']; 
    this.balance = data['balance'];
    this.name = this.meta['name'];
    this.number = this.meta['number'];
    this.availBalance = this.balance['available'];
    this.curBalance = this.balance['current'];
    this.currency = 'null';
    this.publicKey = 'null';
  }

}