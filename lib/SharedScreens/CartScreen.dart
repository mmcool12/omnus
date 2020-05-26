import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:omnus/Components/CartTile.dart';
import 'package:omnus/Firestore/OrderFunctions.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/Meal.dart';
import 'package:omnus/Models/User.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget{
  const CartScreen({Key key, this.buyer}) : super(key: key);
  final User buyer;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Cart cart = Provider.of<Cart>(context);
    
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
           title: Text(
             'Your Cart',
            style: TextStyle(color: Colors.black),
          ),
          ios: (_) => CupertinoNavigationBarData(transitionBetweenRoutes: false),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: cart.length,
            itemBuilder: (context, index) {
              return CartTile(meal: cart.items[index]);
            }
          ),
          Positioned(
          bottom: 0,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Container(
              width: double.infinity,
              child: FlatButton(
                highlightColor: Colors.white,
                splashColor: Colors.white10,
                onPressed: () async {
                  if(cart.hasItems) {
                    for (List<Meal> meals in cart.items){
                      if (meals[0].chefId == buyer.chefId){
                        showSimpleNotification(
                          Text('You cannot order from yourself'),
                          background: Colors.redAccent
                        );
                        return null;
                      }
                    }
                    await showPlatformModalSheet(
                      context: context, 
                      builder: (BuildContext context) {
                        OrderFunctions().createOrder(cart, buyer)
                        .then((results) => Navigator.pop(context));
                        return Center(child: PlatformCircularProgressIndicator());
                      }
                    );
                    cart.clear();
                    Future.delayed(Duration(milliseconds: 300), () async {
                      showSimpleNotification(
                        Text('Request complete'),
                        background: Colors.tealAccent[400]
                      );
                  });
                  } else{
                    showSimpleNotification(
                      Text('Your cart is empty'),
                      background: Colors.redAccent
                    );
                  }
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
                        'Request - ${cart.formatPrice(cart.price)}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          )),
        ],
      ),

    );
  }

}