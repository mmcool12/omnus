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
      'bio' : '',
      'menu' : [],
      'zip' : user.zipcode,
      'images' : [],
      'tags' : [],
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

  Future<DocumentSnapshot> getChef(String id){
    return _db.collection('chefs').document(id).get();
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

  Future<QuerySnapshot> getRequestById(String id) async {
    return await _db.collection('orders').where('chefId', isEqualTo: id).getDocuments();
  }

  updateBio(Chef chef, String bio) async {
    await _db.collection('chefs').document(chef.id).updateData({
      'bio' : bio.trimRight(),
    });
  }

  String cleanTags(String tags){
    tags = tags.trimRight();
    int space = tags.indexOf(' ');
    if (space > 0){
      tags.substring(0, space);
      return tags.trimRight();
    } else {
      return tags;
    }
  }

  updateTags(Chef chef, String tags) async {
    await _db.collection('chefs').document(chef.id).updateData({
      'tags' : [tags],
    });
  }

  updateBioTag(Chef chef, String tags, String bio) async {
    if (chef.tags[0] != cleanTags(tags)){
      updateTags(chef, cleanTags(tags));
    } 
    if (chef.bio != bio.trimRight()){
      updateBio(chef, bio.trimRight());
    }
  }

}