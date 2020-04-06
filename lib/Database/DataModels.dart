

import 'package:omnus/Models/Account.dart';

class StoredAccount {

String number;
String publicKey;
String accessKey;
String name;
String type;
String availableBalance;
String currentBalance;
String itemId;

StoredAccount();

StoredAccount.fromAccount(Account account) {
  number = account.number;
  publicKey = account.publicKey;
  accessKey = account.accessKey;
  itemId = account.itemId;
  name = account.name;
  type = account.type;
  availableBalance = account.availBalance.toString();
  currentBalance = account.curBalance.toString();
}

StoredAccount.fromMap(Map<String, dynamic> map) {
  number = map['number'];
  publicKey = map['pkey'];
  accessKey = map["akey"];
  itemId = map["itemid"];
  name = map['name'];
  type = map['type'];
  availableBalance = map['abalance'];
  currentBalance = map['cbalance'];
}

Map<String, dynamic> toMap() {
  return {
    'pkey' : publicKey,
    'akey' : accessKey,
    'itemid' : itemId,
    'name' : name,
    'type' : type,
    'number' : number,
    'abalance' : availableBalance,
    'cbalance' : currentBalance
  };
}
}
