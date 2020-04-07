
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chefName;

  Chat();

  Chat.fromFirestore(DocumentSnapshot snap) {
    this.chefName = snap.data['chefName'];
  }
}