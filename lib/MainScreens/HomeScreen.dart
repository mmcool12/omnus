import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/SearchBar.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/MainScreens/ChefDetailsScreen.dart';
//import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searching = false;
  String query = "";
  Chef hey = new Chef(id: 'sjkjkd', rate: 6, name: 'yummy', menu: {});

  //Unused
  void showChefPopup(BuildContext context, Chef chef) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Dialog chefPopup = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        height: height * .4,
        width: width * .9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(chef.name),
              FlatButton(
                  onPressed: null,
                  child: Container(
                    color: Colors.blue,
                    height: height * .05,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Message ${chef.name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => chefPopup);
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
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hello, ${user.firstName}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            // IconButton(
            //     icon: Icon(
            //       Icons.search,
            //       color: Colors.black,
            //     ),
            //     onPressed: () =>
            //         showSearch(context: context, delegate: SearchBar())
            // ),
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: SearchFunctions().getAllChefs(),
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
                      child: GridCard(chefs: chefs, index: index,),
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
    @required this.index
  }) : super(key: key);

  final List<Chef> chefs;
  final int index;

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
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ChefDetailsScreen(chef: chefs[index]))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: FutureBuilder<dynamic>(
                  future: ImageFunctions().getImage(chefs[index].mainImage),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      return FadeInImage.memoryNetwork(
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 200),
                        placeholder: kTransparentImage, 
                        image: snapshot.data
                      );
                    } else {
                      return Center(child: Text('Loading'));
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
                          Text(
                            chefType(chefs[index].type),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          GFRating(
                            allowHalfRating: true,
                            value: chefs[index].rating,
                            color: Colors.amber,
                            borderColor: Colors.amber,
                            size: 25,
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
