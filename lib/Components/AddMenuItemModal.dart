import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';

class AddMenuItemModal {
  showModal(BuildContext context, Chef chef) async {
    showPlatformModalSheet(
      context: context,
      builder: (context) => PlatformWidget(
          android: (context) => androidModal(context, chef),
          ios: (context) => iphoneModal(context, chef)),
    );
  }

  Widget androidModal(BuildContext context, Chef chef) {
    var type = "";
    var id = "";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
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
                        .pickThenUploadProfile(ImageSource.gallery, id)
                        .then((result) => Navigator.pop(context));
                  } else if (type == 'chef') {
                    await ImageFunctions()
                        .pickThenUploadChefImage(ImageSource.gallery, id)
                        .then((result) => Navigator.pop(context));
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

  Widget iphoneModal(BuildContext context, Chef chef){
    double height = MediaQuery.of(context).size.height;
    TextEditingController nameText = TextEditingController();
    TextEditingController priceText = TextEditingController();
    TextEditingController descText = TextEditingController();

    bool checkDone(){
      if(nameText.text.isNotEmpty && 
        descText.text.isNotEmpty && 
        priceText.text.isNotEmpty){
          return true;
        } else {
          return false;
        }
    }

    Map<String, dynamic> packageMeal(){
      return {
        'title' : nameText.text,
        'description' : descText.text,
        'price' : double.parse(priceText.text),
        'image' : ''
      };
    }

    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                
                width: double.infinity,
                decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
              Expanded( flex: 2, child: Material(color: Colors.transparent, child: dishNameField(nameText))),
              SizedBox(width: 15),
              Expanded(child: Material(color: Colors.transparent, child: dishPriceField(priceText))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Material(color: Colors.transparent, child: dishDescriptionField(descText))
                          ]
                        ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          print('pressed');
                          return Navigator.pop(context);
                        },
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
                      GestureDetector(
                        onTap: () async {
                          if(checkDone()){
                            await ChefFunctions().addMenuItem(chef.id, packageMeal());
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                            'Add',
                          style: TextStyle(
                            color: Colors.greenAccent[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: window.viewInsets.bottom/2)
            ],
          ),
        ),
    );
  }


      Widget dishDescriptionField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Description',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 90,
          child: TextFormField(
            autovalidate: true,
            validator: (text) => text == "" ? 'Must include description' : null,
            controller: controller,
            minLines: 2,
            maxLines: 3,
            obscureText: false,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintText: 'Description',
                hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }
   
    Widget dishPriceField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Price',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextFormField(
            autovalidate: true,
            validator: (text) => text.isEmpty ? "Must add price" : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            controller: controller,
            obscureText: false,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintText: 'Price',
                hintStyle: kHintTextStyle
            ),
          ),
        )
      ],
    );
  }

  Widget dishNameField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Dish Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextFormField(
            autovalidate: true,
            validator: (text) => text.isEmpty ? "Must include name" : null,
            controller: controller,
            obscureText: false,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintText: 'Dish Name',
                hintStyle: kHintTextStyle
            ),
          ),
        )
      ],
    );
  }

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.blueAccent.shade100,//Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );



}
