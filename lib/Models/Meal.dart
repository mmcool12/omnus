
class Meal{
  String title;
  String description;
  double price;
  String image;

  bool get hasImage => this.image == "" ? false : true;

  Meal.fromMap(Map<String, dynamic> map){
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'].toDouble();
    this.image = map['image'];
  }
}