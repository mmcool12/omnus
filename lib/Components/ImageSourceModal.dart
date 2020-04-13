import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';

class ImageSourceModal {

  bool changed = false;
  
  Future<bool> showModal(BuildContext context, String type, String id) async {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
          android: (_) => androidModal(context, type, id),
          ios: (_) => iphoneModal(context, type, id)),
    );
    return changed;
  }

  Widget androidModal(BuildContext context, String type, String id) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              child: InkWell(
                onTap: () async {
                  if (type == 'userProfile') {
                    await ImageFunctions()
                        .pickThenUploadProfile(ImageSource.camera, id);
                    Navigator.pop(context);
                  } else if (type == 'chef') {
                    await ImageFunctions()
                        .pickThenUploadProfile(ImageSource.camera, id);
                    Navigator.pop(context);
                  }
                },
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Image from Camera'),
                ),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () async {
                  if (type == 'userProfile') {
                    await ImageFunctions()
                        .pickThenUploadProfile(ImageSource.gallery, id).then(
                          (result) => Navigator.pop(context));
                  } else if (type == 'chef') {
                    await ImageFunctions()
                        .pickThenUploadChefImage(ImageSource.gallery, id).then(
                          (result) => Navigator.pop(context));
                  }
                },
                child: ListTile(
                  leading: Icon(Icons.photo_size_select_actual),
                  title: Text('Image from Photos'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iphoneModal(BuildContext context, String type, String id) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (type == 'userProfile') {
                          await ImageFunctions()
                              .pickThenUploadProfile(ImageSource.camera, id);
                          Navigator.pop(context);
                        } else if (type == 'chef') {
                          await ImageFunctions()
                              .pickThenUploadChefImage(ImageSource.camera, id);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: .5))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Choose From Camera',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 21,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (type == 'userProfile') {
                          await ImageFunctions()
                              .pickThenUploadProfile(ImageSource.gallery, id);
                          Navigator.pop(context);
                        } else if (type == 'chef') {
                          await ImageFunctions()
                        .pickThenUploadChefImage(ImageSource.gallery, id).then(
                          (result) => Navigator.pop(context));
                          print('pop');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Choose From Gallery',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 21,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ])),
              Padding(padding: EdgeInsets.symmetric(vertical: 6)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
