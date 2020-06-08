import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ReviewFunctions.dart';
import 'package:omnus/Models/Order.dart';

class CreateReviewModal {
  showModal(BuildContext context, Order order) async {
    showPlatformModalSheet(
      context: context,
      builder: (context) => PlatformWidget(
          android: (context) => androidModal(context, order),
          ios: (context) => iphoneModal(context, order)),
    );
  }

  Widget androidModal(BuildContext context, Order order) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              child: ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Image from Camera'),
              ),
            ),
            Material(
              child: ListTile(
                leading: Icon(Icons.photo_size_select_actual),
                title: Text('Image from Photos'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iphoneModal(BuildContext context, Order order){
    double height = MediaQuery.of(context).size.height;
    TextEditingController titleText = TextEditingController();
    TextEditingController ratingText = TextEditingController();
    TextEditingController descText = TextEditingController();

    bool checkDone(){
      if(titleText.text.isNotEmpty && 
        descText.text.isNotEmpty && 
        ratingText.text.isNotEmpty){
          return true;
        } else {
          return false;
        }
    }

    return WillPopScope(
      onWillPop: () async {
        return checkDone();
      },
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
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
                  Expanded( flex: 2, child: Material(color: Colors.transparent, child: reviewTitleField(titleText))),
                  SizedBox(width: 15),
                  Expanded(child: Material(color: Colors.transparent, child: reviewRatingField(ratingText))),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Material(color: Colors.transparent, child: dishDescriptionField(descText))
                              ]
                            ),
                        )),
                  Padding(padding: EdgeInsets.symmetric(vertical: 6)),
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
                            onTap: () {
                              Navigator.pop(context);
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
                                double rating = (double.parse(ratingText.text) > 5 ? 5.0 : double.parse(ratingText.text));
                                await ReviewFunctions().createReview(order, descText.text, rating, titleText.text);
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
          ),
        ),
     );
  }


      Widget dishDescriptionField(TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
   
    Widget reviewRatingField(TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Rating (0-5)',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextFormField(
            autovalidate: true,
            validator: (text) => text.isEmpty ? "Add rating" : null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            controller: controller,
            obscureText: false,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintText: 'Rating',
                hintStyle: kHintTextStyle
            ),
          ),
        )
      ],
    );
  }

  Widget reviewTitleField(TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Review Title',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextFormField(
            autovalidate: true,
            validator: (text) => text.isEmpty ? "Must include title" : null,
            controller: controller,
            obscureText: false,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintText: 'Title',
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
