import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/SharedScreens/CartScreen.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key key, @required this.cart, @required this.padding, @required this.buyerId}) : super(key: key);
  final Cart cart;
  final bool padding;
  final String buyerId;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (cart.hasItems) {
      return Positioned(
          bottom: this.padding ? height*.1 : 0,
          width: width,
          child: Padding(
            padding: this.padding ? const EdgeInsets.symmetric(horizontal: 8.0) : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Container(
              width: double.infinity,
              child: FlatButton(
                highlightColor: Colors.white,
                splashColor: Colors.white10,
                onPressed: () {
                  Navigator.push(context, platformPageRoute(context: context, builder: (_) => CartScreen(buyerId: buyerId)));
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
                        'View Cart - ${cart.numItems}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          ));
    } else {
      return SizedBox(height: 0, width: 0);
    }
  }
}
