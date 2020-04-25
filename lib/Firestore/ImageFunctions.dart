import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageFunctions {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://titan-2a457.appspot.com/');

  Future<dynamic> getImage(String filePath) async {
    return _storage.ref().child(filePath).getDownloadURL();
  }

  Future<List<dynamic>> getChefsImages(List<dynamic> filePaths) async {
    List<dynamic> images = [];
    for (String path in filePaths) {
      await _storage
          .ref()
          .child(path)
          .getDownloadURL()
          .then((path) => images.add(path));
    }
    return images;
  }

  Future<File> pickImage(ImageSource source) async {
    return await ImagePicker.pickImage(source: source);
  }

  Future<String> uploadImage(File image, String userId, String path) async {
    String filePath;
    if (path != "profileImages") {
      filePath = '$path/${DateTime.now()}.png';
    } else {
      filePath = '$path/$userId.png';
    }

    await _storage.ref().child(filePath).putFile(image).onComplete;
    return filePath;
  }

  Future<String> pickThenUploadProfile(
      ImageSource source, String userId) async {
    File image = await pickImage(source);
    if (image != null ) {
      String filePath = await uploadImage(image, userId, 'profileImages');
      await _db.collection('users').document(userId).updateData(
          {'profileImage': filePath});
    }

    return "done";
  }

  Future<String>  pickThenUploadChefImage(ImageSource source, String chefId) async {
    File image = await pickImage(source);
    if (image != null) {
      String filePath;
      await uploadImage(image, chefId, "chef$chefId")
          .then((path) => filePath = path);
      await _db.collection('chefs').document(chefId).updateData({
        'images': FieldValue.arrayUnion([filePath])
      });
    return "done";
    }
    return null;
  }

  Future<String>  pickThenUploadChefProfileImage(ImageSource source, String chefId) async {
    File image = await pickImage(source);
    if (image != null) {
      String filePath;
      await uploadImage(image, chefId, "profile/$chefId")
          .then((path) => filePath = path);
      await _db.collection('chefs').document(chefId).updateData({
        'profileImage': filePath
      });
    return "done";
    }
    return null;
  }
}
