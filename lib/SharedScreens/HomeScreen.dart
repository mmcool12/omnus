import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/CartButton.dart';
import 'package:omnus/Components/GridCard.dart';
import 'package:omnus/Components/ProfileModal.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Firestore/NotificationFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<QuerySnapshot> allChefs;

  @override
  void initState() {
    print('bye');
    allChefs = SearchFunctions().getAllChefs();
    //NotificationFunctions().tokenCheck(user.uid);
    super.initState();
  }


  Widget title = Text('Hello');
  Widget leading = Icon(Icons.search);


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
      NotificationFunctions().saveNewToken(user);
      return PlatformScaffold(
        iosContentBottomPadding: true,
        appBar: PlatformAppBar(
          backgroundColor: Colors.white,
           title: Text(
             'Discover',
            style: TextStyle(color: Colors.black),
          ),
          trailingActions: <Widget>[
            GestureDetector( 
              onTap: () async => ProfileModal().showModal(context, user),
              child: Icon(CupertinoIcons.profile_circled),)
          ],
          ios: (_) => CupertinoNavigationBarData(transitionBetweenRoutes: false),
        ),
        body: Stack(
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
                future: allChefs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Chef> chefs = [];
                    for (DocumentSnapshot snap in snapshot.data.documents)
                      chefs.add(Chef.fromFirestore(snap));
                    //chefs.removeWhere((chef) => chef.id == user.chefId);
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
    } else {
      return Center(child: PlatformCircularProgressIndicator());
    }
  }
}

