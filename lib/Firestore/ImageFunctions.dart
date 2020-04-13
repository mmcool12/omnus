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

    Future<List<dynamic>> getChefsImages(List<dynamic> filePaths) async {
      List<dynamic> images = [];
      for(String path in filePaths){
        await _storage.ref().child(path).getDownloadURL().then(
          (path) => images.add(path)
        );
      }
      return images;
  }

  Future<File> pickImage(ImageSource source) async {
    return await ImagePicker.pickImage(source: source);
  }

  Future<String> uploadImage(File image, String userId, String path) async{
    String filePath;
    if (path != "profileImages"){
      filePath = '$path/${DateTime.now()}.png';
    } else {
      filePath = '$path/$userId.png';
    }

    _uploadTask = _storage.ref().child(filePath).putFile(image);
    return filePath;
  }

  Future<String> pickThenUploadProfile(ImageSource source, String userId) async {
    String toReturn; 
    File image = await pickImage(source);
    if (image != null){
      String filePath = await uploadImage(image, userId, 'profileImages');
      await _db.collection('users').document(userId).updateData({
        'profileImage' : filePath
      }).then(
        (path) => toReturn = "Done"
      );
    }

    return toReturn;
  }

  Future<String> pickThenUploadChefImage(ImageSource source, String chefId) async {
    String toReturn;
    File image = await pickImage(source);
    if (image != null){
      String filePath;
      await uploadImage(image, chefId, "chef$chefId").then(
        (path) => filePath = path
      ).then( (result) async =>
      await _db.collection('chefs').document(chefId).updateData({
        'images' : FieldValue.arrayUnion([
          filePath
        ])
      }).then((path) => toReturn = 'done'));
    }
      return toReturn;
  }

}