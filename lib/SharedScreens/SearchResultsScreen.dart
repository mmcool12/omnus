import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/CartButton.dart';
import 'package:omnus/Components/GridCard.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Firestore/NotificationFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    Key key,
    @required this.tag,
    @required this.user
  }) : super(key: key);

  final String tag;
  final User user;
  
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  User user;
  Future<QuerySnapshot> queriedChefs;

  @override
  void initState() {
    queriedChefs = SearchFunctions().getChefByTag(widget.tag);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        iosContentBottomPadding: true,
        appBar: PlatformAppBar(
          backgroundColor: Colors.white,
           title: Text(
             widget.tag,
            style: TextStyle(color: Colors.black),
          ),
          ios: (_) => CupertinoNavigationBarData(transitionBetweenRoutes: false),
        ),
        body: Stack(
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
                future: queriedChefs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Chef> chefs = [];
                    for (DocumentSnapshot snap in snapshot.data.documents)
                      chefs.add(Chef.fromFirestore(snap));
                    chefs.sort((a, b) => b.numReviews.compareTo(a.numReviews));
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridCard(chef: chefs[index], user: user),
                        );
                      },
                      itemCount: chefs.length,
                    );
                  } else {
                    return Center(child: PlatformCircularProgressIndicator());
                  }
                }),
                Consumer<Cart>(builder: (BuildContext context, Cart cart, Widget child) {
              return CartButton(cart: cart, padding: false, buyer: user);
            },),
          ],
        ),
      );
    } 
  }

