import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/CartButton.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/SharedScreens/SearchResultsScreen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final searchTerms = <String>['American', 'Italian', 'Thai', '10 or under'];

  @override
  Widget build(BuildContext context) {
    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    if (user != null) {
      return PlatformScaffold(
          appBar: PlatformAppBar(
            title: Text('Search'),
            ios: (_) =>
                CupertinoNavigationBarData(transitionBetweenRoutes: false),
          ),
          body: Stack(
            children: <Widget>[
              GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: EdgeInsets.all(12),
                  children: List.generate(
                    searchTerms.length,
                    (index) {
                      String term = searchTerms[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.push(
                            context,
                            platformPageRoute(
                                context: context,
                                builder: (BuildContext context) =>
                                    SearchResultsScreen(
                                        tag: term, user: user))),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x36000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              (term.startsWith("1")
                                  ? Text(
                                      '\$10',
                                      style: TextStyle(
                                        fontFamily: 'Apple SD Gothic Neo',
                                        fontSize: 56,
                                        color: const Color(0xff4e4e4e),
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.w700,
                                        height: 1
                                      ),
                                    )
                                  : Icon(
                                      Icons.fastfood,
                                      size: 56,
                                    )),
                              term.startsWith('1') ? SizedBox(): const SizedBox(height: 4),
                              Text(
                                term,
                                style: TextStyle(
                                  fontFamily: 'Apple SD Gothic Neo',
                                  fontSize: 24,
                                  color: Colors.black,
                                  letterSpacing: 0.17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
              Consumer<Cart>(
                builder: (BuildContext context, Cart cart, Widget child) {
                  return CartButton(cart: cart, padding: false, buyer: user);
                },
              ),
            ],
          ));
    } else {
      return Center(child: PlatformCircularProgressIndicator());
    }
  }
}
