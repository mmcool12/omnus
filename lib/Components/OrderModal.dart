import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Meal.dart';
import 'package:provider/provider.dart';

class OrderModal {
  showModal(BuildContext context, Chef chef, Meal meal) async {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
          android: (_) => androidModal(context, chef),
          ios: (_) => iphoneModal(context, chef, meal)),
    );
  }

  Widget androidModal(BuildContext context, Chef chef) {}

  Widget iphoneModal(BuildContext context, Chef chef, Meal meal) {
    
    
    double height = MediaQuery.of(context).size.height;
    int quantity = 1;

    var orderStyle = TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                );

    String getPrice(double price){
      if(price == 0.0){
        return '\$0';
      } else if(price.roundToDouble() == price){
        return '\$${price.round() * quantity}';
      } else {
        return '\$${(price * quantity)}';
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: meal.hasImage ? height * .5 : height * .35,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Request ${meal.title}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 15),
                (meal.hasImage
                    ? Container(
                        height: height * .2,
                        child: CachedNetworkImage(
                          imageUrl: meal.fireImage,
                          placeholder: (context, url) =>
                              PlatformCircularProgressIndicator(),
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container()),
                (meal.hasImage ? SizedBox(height: 15) : Container()),
                RichText(
                  textAlign: TextAlign.left,
                  maxLines: 4,
                  text: TextSpan(
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Description: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: meal.description)
                      ]),
                ),
                Row(
                  children: <Widget>[],
                ),
                Spacer(),
                Provider<int>(
                  create: (_) =>  quantity,
                  lazy: true,
                                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                                color: Colors.tealAccent[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(child: Container( child: Text('-', style: orderStyle)), onTap: () {quantity--; print(quantity);}),
                                Text('1', style: orderStyle,),
                                Text('+', style: orderStyle,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: FlatButton(
                            onPressed: () => print('request'),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.tealAccent[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Cost: ${getPrice(meal.price)}',
                                  style: orderStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
