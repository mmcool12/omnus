import 'package:flutter/foundation.dart';
import 'package:omnus/Models/Meal.dart';

class Cart extends ChangeNotifier {
  final List<List<Meal>> items = [];

  Cart();

  factory Cart.fromList(List<List<Meal>> meals){
    Cart cart = Cart();
    for (List<Meal> meal in meals) cart.items.add(meal);
    return cart;
  }

   int get length => this.items.length;
   bool get hasItems => this.items.length > 0;

   int get numItems {
     int counter  = 0;
     for(List<Meal> list in items){
       counter += list.length;
     }
     return counter;
   }

   double get price {
     double price = 0;
     for(List<Meal> list in items){
       for (Meal meal in list){
         price += meal.price;
       }
     }
     return price;
   }

  
  String formatPrice(double price){
    if(price.roundToDouble() == price){
      return '\$${price.round()}';
    } else {
      return '\$$price';
    }
  }
  
  void add(List<Meal> meal) {
    bool added = false;
    if (items.isNotEmpty) {
      for(var i = 0; i < items.length; i++){
        if(this.items[i][0].title == meal[0].title && items[i][0].title == meal[0].title){
          items[i] = items[i] + meal;
          added = true;
          break;
        }
      } 
    }
    if(!added) {
      items.add(meal);
    }
    notifyListeners();
  }

  void remove(List<Meal> meal){
    items.remove(meal);
    notifyListeners();
  }


  void clear(){
    items.clear();
    notifyListeners();
  }
}