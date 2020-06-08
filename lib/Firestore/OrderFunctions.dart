import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/Meal.dart';
import 'package:omnus/Models/User.dart';

class OrderFunctions{

  final Firestore _db = Firestore.instance;

  Map<String, List<List<Meal>>> getChefsMeals(Cart cart){
    List<List<Meal>> temp = [];
    cart.items.sort((a,b) => a[0].chefId.compareTo(b[0].chefId));
    temp = cart.items;
    
    Map<String, List<List<Meal>>> chefSorted = {};
    while (temp.length > 0){
      chefSorted[temp[0][0].chefId] = temp.where((list) => list[0].chefId == temp[0][0].chefId).toList();
      temp.removeWhere(((list) => list[0].chefId == temp[0][0].chefId));
    }
    return chefSorted;
  }

  List<Map<dynamic, dynamic>> cartToMealMap(Cart cart){
    List<Map<dynamic,dynamic>> orderMap = [];
    for(List<Meal> list in cart.items){
      orderMap.add({
        'name' : list[0].title,
        'quantity' : list.length
      });
    }
    return orderMap;
  }

  Future<String> createOrder(Cart cart, User buyer) async {
    Map<String, List<List<Meal>>> chefSorted = getChefsMeals(cart);
    for(String chefId in chefSorted.keys){
      Cart temp = Cart.fromList(chefSorted[chefId]);
      await _db.collection('orders').add({
        'buyerId' : buyer.id,
        'chefId' : chefId,
        'chefName' : temp.items[0][0].chefName,
        'buyerName' : buyer.name,
        'buyerLocation' : 'location',
        'price' : temp.price,
        'accepted' : false,
        'rejected' : false,
        'completed' : false,
        'meals' : cartToMealMap(temp)
      });
    }
    return "sucsess";
    
  }

  cancelOrder(String orderId) async {
    return await _db.collection('orders').document(orderId).updateData({
      'completed' : true,
    });
  }

  acceptOrder(String orderId) async {
    return await _db.collection('orders').document(orderId).updateData({
      'accepted' : true,
    });
  }

  rejectOrder(String orderId) async {
    return await _db.collection('orders').document(orderId).updateData({
      'rejected' : true,
    });
  }

  completeOrder(String orderId) async {
    return await _db.collection('orders').document(orderId).updateData({
      'completed' : true,
    });
  }
}