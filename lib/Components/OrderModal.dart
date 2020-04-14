import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Meal.dart';

class OrderModal {
  showModal(BuildContext context, Chef chef, Meal meal) async {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
          android: (_) => androidModal(context, chef),
          ios: (_) => iphoneModal(context, chef, meal)),
    );
  }

  Widget androidModal(BuildContext context, Chef chef) {
    
  }

  Widget iphoneModal(BuildContext context, Chef chef, Meal meal){
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: meal.hasImage ? height*.5 : height*.4,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Text('HELLO')
        ],
      ),
    );
  }

}
