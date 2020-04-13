import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnus/Components/ImageList.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Components/MenuTiles.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Firestore/ReviewFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Review.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ChefEditScreen extends StatefulWidget {
  final String chefId;

  @override
  const ChefEditScreen({
    Key key,
    @required this.chefId,
  }) : super(key: key);

  @override
  _ChefEditScreenState createState() => _ChefEditScreenState();
}

class _ChefEditScreenState extends State<ChefEditScreen> {
  @override
  Widget build(BuildContext context) {
    Chef chef;

    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<DocumentSnapshot>(
        stream: ChefFunctions().getChefStreamById(widget.chefId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return PlatformScaffold(
                body: Center(child: PlatformCircularProgressIndicator()));
          } else {
            chef = Chef.fromFirestore(snapshot.data);
            return PlatformScaffold(
              iosContentPadding: true,
              appBar: PlatformAppBar(
                title: Text(
                  'Your chef profile',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: height * .2,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    radius: 56,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          chef.name,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            (chef.numReviews > 0
                                                ? Text(
                                                    '${chef.rating}',
                                                    style: TextStyle(
                                                      color: Colors.amber,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22,
                                                    ),
                                                  )
                                                : Text(
                                                    'No reviews',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  )),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2)),
                                            Container(
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              child: GFRating(
                                                itemCount: (chef.numReviews > 0
                                                    ? 5
                                                    : 0),
                                                value: chef.rating,
                                                size: 24,
                                                color: Colors.amber,
                                                borderColor: Colors.amber,
                                              ),
                                            ),
                                            Text((chef.numReviews > 0
                                                ? '(${chef.numReviews})'
                                                : ""))
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.blueAccent,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 24.0),
                                            child: Text('See Preview'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      ImageList(height: height, chef: chef, edit: true),
                      SizedBox(height: 20),
                      MenuTiles(chef: chef, edit: true),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}


