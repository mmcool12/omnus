import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      @required this.user
    }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chef ${chef.name}', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height*.2,
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
                                  (chef.numReviews > 0 ? 
                                  Text(
                                    '${chef.rating}',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ) : Text(
                                      'No reviews yet',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                      ),
                                    )
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, index){
                                        return (chef.numReviews > 0 ? 
                                        Icon(
                                          chef.rating > index ? Icons.star : Icons.star_border,
                                          color: Colors.amber,
                                          size: 22,
                                        ) : 
                                        Text('')
                                        );
                                      }
                                    ),
                                  ),
                                ],
                              ),
                              FlatButton(
                                onPressed: () async {
                                  Chat chat;
                                  await ChatFunctions().createChat(user, chef).then((result) => chat = Chat.fromFirestore(result));
                                  return Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => MessagingScreen(user: user, chat: chat)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.blueAccent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:  12.0, horizontal: 24.0),
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
              height: height*.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: height*.2,
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text('Image'),
                      ),
                    ),
                  );
                }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: ReviewFunctions().getReviewsByChefID(chef.id),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data.documents.isNotEmpty){
                      List<Review> reviews = [];
                      for(DocumentSnapshot snap in snapshot.data.documents) reviews.add(Review.fromFirestore(snap));
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 55,
                                ),
                                Text('${reviews[index].rating}',style: TextStyle(color: Colors.black),)
                              ],
                            ),
                            title: Text(reviews[index].title),
                            subtitle: Text(reviews[index].description, maxLines: 2, overflow: TextOverflow.ellipsis,),
                          );
                        } 
                      );
                    } else {
                      return Text('No reviews');
                    }
                  } else{
                    return Text('Loading');
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
