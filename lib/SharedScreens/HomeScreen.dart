import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omnus/Components/CartButton.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Firestore/NotificationFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/SharedScreens/ChefDetailsScreen.dart';
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
           title: Text(
             'Home',
          //   'Hello, ${user.firstName}',
            style: TextStyle(color: Colors.black),
          ),
          ios: (_) => CupertinoNavigationBarData(transitionBetweenRoutes: false),
          trailingActions: <Widget>[
            // Material(
            //   color: Colors.transparent,
            //               child: PlatformIconButton(
            //       //alignment: Alignment.centerLeft,
            //       padding: EdgeInsets.all(8),
            //       androidIcon: Icon(
            //         Icons.search,
            //         size: 20,
            //         color: Colors.black,
            //       ),
            //       iosIcon: Icon(
            //         CupertinoIcons.search,
            //         color: Colors.black,
            //       ),
            //       onPressed: () =>
            //           showSearch(context: context, delegate: SearchBar(user: user))
            //   ),
            // ),
          ],
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
                    chefs.removeWhere((chef) => chef.id == user.chefId);
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
                    return Text("Loading");
                  }
                }),
                Consumer<Cart>(builder: (BuildContext context, Cart cart, Widget child) {
              return CartButton(cart: cart, padding: true, buyer: user);
            },),
          ],
        ),
      );
    } else {
      return Center(child: Text('Loading'));
    }
  }
}

class GridCard extends StatelessWidget {
  const GridCard({
    Key key,
    @required this.chef,
    @required this.user
  }) : super(key: key);

  final Chef chef;
  final User user;

    String chefType(String type) {
    if (type == 'both') {
      return 'Chef & Prep';
    } else if (type == 'chef') {
      return 'Chef';
    } else {
      return 'Prep';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.push(context, 
         platformPageRoute(context: context, builder: (BuildContext context) => ChefDetailsScreen(chef: chef, user: user))),
        child: Stack(
          children: <Widget>[
            Container(
              height: 240,
              decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10)),
              width: double.infinity,
              child: FutureBuilder<dynamic>(
                future: ImageFunctions().getImage(chef.mainImage),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                              imageUrl: snapshot.data,
                              placeholder: (context, url) => Center(child: PlatformCircularProgressIndicator()),
                              fit: BoxFit.cover,
                            ),
                    );
                  } else {
                    return Center(child: PlatformCircularProgressIndicator());
                  }
                }
                ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chef.name,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20 * textScale,
                        shadows: [
                          Shadow( 
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2,
                            //color: Colors.black38.withOpacity(.5)
                          )
                        ]
                      )
                    ),
                    Text(
                      chef.menu[0]['title'],
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * textScale,
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
