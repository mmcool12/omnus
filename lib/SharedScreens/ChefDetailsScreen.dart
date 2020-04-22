import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/CartButton.dart';
import 'package:omnus/Components/ImageList.dart';
import 'package:omnus/Components/MenuTiles.dart';
import 'package:omnus/Components/ReviewTiles.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

import 'MessagingScreen.dart';

class ChefDetailsScreen extends StatelessWidget {

  final Chef chef;
  final User user;

  @override
  ChefDetailsScreen({
    Key key,
    @required this.chef,
    @required this.user,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: Text(
          'Chef ${chef.name}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            primary: true,
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12,12,12,64),
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
                              child: ProfilePic(chef: chef),
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
                                            platformPageRoute(
                                                builder: (context) =>
                                                    MessagingScreen(chat: chat, user: user, type: 'user'), context: context));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: Colors.blueAccent[400],
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
                  ImageList(height: height, chef: chef, edit: false),
                  SizedBox(height: 20),
                  MenuTiles(chef: chef, edit: false),
                  ReviewTile(chef: chef),
                ],
              ),
            ),
          ),
          Consumer<Cart>(builder: (BuildContext context, Cart value, Widget child) {return CartButton(cart: value, padding: false, buyerId: user.id);},)
        ],
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Future<dynamic> profilePic;

  @override
  void initState() {
    profilePic = ImageFunctions().getImage(widget.chef.profileImage);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
          future: this.profilePic,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return CachedNetworkImage(
                imageUrl: snapshot.data ?? null,
                placeholder: (context, url) => SizedBox(height: 128, width: 128, child: Center(child: PlatformCircularProgressIndicator())),
                imageBuilder: (context, imageProvider) => 
                Container(
                  height: 128, //64*2
                  width: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover
                    )
                  ),
                ),
              );
            } else {
              return GFAvatar(
                backgroundColor: Colors.blueAccent[400],
                radius: 56,
                child: Text(
                    widget.chef.firstName.substring(0, 1) +
                        widget.chef.lastName.substring(0, 1),
                    style: TextStyle(fontSize: 56)),
              );
            }
          }
        );
  }
}

