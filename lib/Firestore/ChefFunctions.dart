import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';

class ChefFunctions{

  final Firestore _db = Firestore.instance;

  Future<String> createChef(User user) async {
    DocumentReference ref;

    await _db.collection('chefs').add({
      'firstName' : user.firstName,
      'lastName' : user.lastName,
      'menu' : [],
      'zip' : user.zipcode,
      'images' : [],
      'reviews' : [],
      'rating' : 0,
      'numReviews' : 0,
      'type' : 'none',
      'active' : false,
      'profileImage' : ''
    }).then((result) => ref = result);

    await _db.collection('users').document(user.id).updateData({
      'chefId': ref.documentID
    });

    return ref.documentID;

  }
  
  Stream<DocumentSnapshot> getChefStreamById(String id) {
    return _db.collection('chefs').document(id).snapshots();
  }

   Future<void> addMenuItem(String chefId, Map<String, dynamic> item) async  {
    return await _db.collection('chefs').document(chefId).updateData({
        'menu' : FieldValue.arrayUnion([
          item
        ])
      });
  }

  toggleActive(Chef chef) async {
    await _db.collection('chefs').document(chef.id).updateData({
      'active' : !chef.active
    });
  }

}