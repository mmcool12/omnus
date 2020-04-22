
class Meal{
  String title;
  String description;
  double price;
  String image;
  String fireImage;
  String chefId;

  bool get hasImage => this.image == "" ? false : true;

  Meal.fromMap(Map<dynamic, dynamic> map){
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'].toDouble();
    this.image = map['image'];
    this.fireImage = map['fireImage'] ?? "";
    this.chefId = map['chefId'];
  }
}