import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/Meal.dart';
import 'package:provider/provider.dart';

class OrderModal {
  showModal(BuildContext context, Meal meal, bool edit) async {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
          android: (_) => androidModal(context),
          ios: (_) => iphoneModal(context, meal, edit)),
    );
  }

  Widget androidModal(BuildContext context) {return Container();}

  String getPrice(double price, int quantity) {
    if (price == 0.0) {
      return '\$0';
    } else if (price.roundToDouble() == price) {
      return '\$${price.round() * quantity}';
    } else {
      return '\$${(price * quantity)}';
    }
  }

  Widget iphoneModal(BuildContext context, Meal meal, bool edit) {
    Cart cart = Provider.of<Cart>(context, listen: false);
    
    double height = MediaQuery.of(context).size.height;

    var orderStyle = TextStyle(
        fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold);

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
                PillCounter(orderStyle: orderStyle, meal: meal, cart: cart)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PillCounter extends StatefulWidget {
  const PillCounter({
    Key key,
    @required this.orderStyle,
    @required this.meal,
    @required this.cart,
  }) : super(key: key);

  final TextStyle orderStyle;
  final Meal meal;
  final Cart cart;

  @override
  _PillCounterState createState() => _PillCounterState();
}

class _PillCounterState extends State<PillCounter> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.tealAccent[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          child: Container(
                              child: Text('-', style: widget.orderStyle)),
                          onTap: () => quantity > 1
                              ? this.setState(() {
                                  quantity--;
                                })
                              : null)),
                  Center(
                      child: Text(
                    quantity.toString(),
                    style: widget.orderStyle,
                  )),
                  Expanded(
                      child: GestureDetector(
                          child: Container(
                              child: Text(
                            '+',
                            style: widget.orderStyle,
                            textAlign: TextAlign.right,
                          )),
                          onTap: () => this.setState(() {
                                quantity++;
                              }))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: FlatButton(
              highlightColor: Colors.white,
              splashColor: Colors.white10,
              onPressed: () {
                List<Meal> temp = [];
                for (var i = 0; i < quantity; i++) temp.add(widget.meal);
                widget.cart.add(temp);
                Fluttertoast.showToast(
                    msg: 'Added $quantity items',
                    backgroundColor: Colors.tealAccent[400],
                    gravity: ToastGravity.CENTER);
                Future.delayed(const Duration(milliseconds: 500),
                    () => Navigator.pop(context));
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.tealAccent[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cost: ${OrderModal().getPrice(widget.meal.price, quantity)}',
                    style: widget.orderStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
