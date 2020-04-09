import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnus/Firestore/UserFunctions.dart';

class ImageFunctions {
  
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://titan-2a457.appspot.com/');
  StorageUploadTask _uploadTask;
  

  Future<dynamic> getImage(String filePath) async {
    return _storage.ref().child(filePath).getDownloadURL();
  }

  Future<File> pickImage(ImageSource source) async {
    return await ImagePicker.pickImage(source: source);
  }

  Future<String> uploadImage(File image, String userId, String path) async{
    String filePath;
    if (userId == ""){
      filePath = '$path/${DateTime.now()}.png';
    } else {
      filePath = '$path/$userId.png';
    }

    _uploadTask = _storage.ref().child(filePath).putFile(image);
    return filePath;
  }

  pickThenUploadProfile(ImageSource source, String userId) async {
    File image = await pickImage(source);
    if (image != null){
      String filePath = await uploadImage(image, userId, 'profileImages');
      await _db.collection('users').document(userId).updateData({
        'profileImage' : filePath
      });
    }

  }
}