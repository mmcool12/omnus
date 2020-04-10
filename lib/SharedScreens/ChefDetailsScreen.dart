import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Firestore/ReviewFunctions.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Review.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

import 'MessagingScreen.dart';

class ChefDetailsScreen extends StatelessWidget {
  final Chef chef;
  final User user;

  @override
  const ChefDetailsScreen({
    Key key,
    @required this.chef,
    @required this.user,
  }) : super(key: key);

  List<Widget> getMenu() {
    List<Widget> toReturn = [];
    chef.menu.forEach((key, value) => toReturn.add(ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(key),
            subtitle: Text(value),
            isThreeLine: true,
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
            child: Container(
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: .5))),
            ),
          );
        },
        itemCount: chef.menu.length)));
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chef ${chef.name}',
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    (chef.numReviews > 0
                                        ? Text(
                                            '${chef.rating}',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
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
                                        itemCount: (chef.numReviews > 0 ? 5: 0),
                                        value: chef.rating,
                                        size: 24,
                                        color: Colors.amber,
                                        borderColor: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      (chef.numReviews > 0 ? '(${chef.numReviews})' : "")                                      
                                    )
                                  ],
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    Chat chat;
                                    await ChatFunctions()
                                        .createChat(user, chef)
                                        .then((result) =>
                                            chat = Chat.fromFirestore(result));
                                    return Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MessagingScreen(chat: chat, user: user)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 24.0),
                                      child: Text('Message ${chef.firstName}'),
                                    ),
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
              Container(
                height: height * .2,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: height * .2,
                          color: Colors.blueAccent,
                          child: Center(
                            child: Text('Image'),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: Text(
                  'Menu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              MenuTiles(chef: chef),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Text(
                  'Reviews',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              ReviewTile(chef: chef),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: ReviewFunctions().getReviewsByChefID(chef.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isNotEmpty) {
              List<Review> reviews = [];
              for (DocumentSnapshot snap in snapshot.data.documents)
                reviews.add(Review.fromFirestore(snap));
              return Container(
                decoration:
                    BoxDecoration(border: Border(top: BorderSide(width: .5))),
                child: ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 55,
                              ),
                              Text(
                                '${reviews[index].rating}',
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          title: Text(reviews[index].title),
                          subtitle: Text(
                            reviews[index].description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: .5))),
              ),
            );
          },
                  ),
              );
            } else {
              return Center(
                child: Text('No reviews',
                style: TextStyle(
                  fontSize: 20
                ),)
              );
            }
          } else {
            return Text('Loading');
          }
        });
  }
}

class MenuTiles extends StatelessWidget {
  const MenuTiles({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  Widget build(BuildContext context) {
    List<Widget> toReturn = [];

    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(width: .5))),
      child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            List<dynamic> keys = chef.menu.keys.toList();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListTile(
                dense: true,
                title: Text(
                  keys[index],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  chef.menu[keys[index]],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                isThreeLine: true,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: .5))),
              ),
            );
          },
          itemCount: chef.menu.length),
    );
  }
}
