
class Account{
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
    this.name = this.meta['name'];
    this.number = this.meta['number'];
    this.availBalance = this.balance['available'];
    this.curBalance = this.balance['current'];
    this.currency = '';
  }

  Account.fromMap(Map<String, dynamic> data){
    this.id = data['id'];
    this.type = data['type'];
    this.subtype = data['subtype'];
    this.meta = data['meta']; 
    this.balance = data['balance'];

    this.name = this.meta['name'];
    this.number = this.meta['number'];
    this.availBalance = this.balance['available'];
    this.curBalance = this.balance['current'];
    this.currency = '';
  }

}