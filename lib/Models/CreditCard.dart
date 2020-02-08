
class CreditCard{
  final String id;
  final String type;
  final String subtype; 
  Map balance;
  Map localized;
  Map meta;

  String name;
  String number;
  double availBalance;
  double curBalance;

  CreditCard(this.id, this.type, this.subtype, this.balance, this.localized, this.meta){
    this.name = this.meta['name'];
    this.number = this.meta['number'];
    this.availBalance = this.balance['available'];
    this.curBalance = this.balance['current'];
  }
}