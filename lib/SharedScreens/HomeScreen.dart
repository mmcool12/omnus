import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/SearchBar.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/SharedScreens/ChefDetailsScreen.dart';
//import 'package:omnus/Auth/AuthFunctions.dart';
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
    allChefs = SearchFunctions().getAllChefs();
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
      return PlatformScaffold(
        appBar: PlatformAppBar(
           title: Text(
             'Search',
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
        body: FutureBuilder<QuerySnapshot>(
            future: allChefs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Chef> chefs = [];
                for (DocumentSnapshot snap in snapshot.data.documents)
                  chefs.add(Chef.fromFirestore(snap));
                chefs.sort((a, b) => b.numReviews.compareTo(a.numReviews));
                return GridView.count(
                  crossAxisCount: 1,
                  children: List.generate(chefs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: GridCard(chefs: chefs, index: index,user: user),
                    );
                  }),
                );
              } else {
                return Text("Loading");
              }
            }),
      );
    } else {
      return Center(child: Text('Loading'));
    }
  }
}

class GridCard extends StatelessWidget {
  const GridCard({
    Key key,
    @required this.chefs,
    @required this.index,
    @required this.user
  }) : super(key: key);

  final List<Chef> chefs;
  final int index;
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
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, 
         platformPageRoute(context: context, builder: (BuildContext context) => ChefDetailsScreen(chef: chefs[index], user: user))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: FutureBuilder<dynamic>(
                  future: ImageFunctions().getImage(chefs[index].mainImage),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                      return CachedNetworkImage(
                              imageUrl: snapshot.data,
                              placeholder: (context, url) => Center(child: PlatformCircularProgressIndicator()),
                              fit: BoxFit.fitHeight,
                            );
                    } else {
                      return Center(child: PlatformCircularProgressIndicator());
                    }
                  }
                  ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        chefs[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1)),
                      Row(
                        children: <Widget>[
                          // Text(
                          //   chefType(chefs[index].type),
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //   ),
                          // ),
                          GFRating(
                            allowHalfRating: true,
                            value: chefs[index].rating,
                            color: Colors.amber,
                            borderColor: Colors.amber,
                            size: 25,
                          ),
                          Text(
                            '(${chefs[index].numReviews})'
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
