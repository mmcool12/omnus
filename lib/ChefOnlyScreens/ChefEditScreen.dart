import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/ImageList.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Components/MenuTiles.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';

class ChefEditScreen extends StatefulWidget {
  final String chefId;
  final String userId;

  @override
  const ChefEditScreen({
    Key key,
    @required this.chefId,
    @required this.userId
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
                                  child: ChefPic(chef: chef)
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
                                        ActiveToggle(chef: chef, userId: widget.userId,)
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

class ActiveToggle extends StatelessWidget {
  const ActiveToggle({
    Key key,
    @required this.chef,
    @required this.userId
  }) : super(key: key);

  final Chef chef;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        var ready = true;
        var subtitle = 'This means other people will be able to see and search for your profile. Are you ready?';

        if (chef.menu.length > 1 && chef.images.length > 1 && chef.profileImage == ""){
          subtitle = 'Add picture but okay';
        }
        if(chef.menu.length == 0 && chef.images.length == 0){
          ready = false;
          subtitle = 'Must add menu item and picture to be active';
        }
        if(chef.active){
          subtitle = "This means you will no longer get order request";
        }
        String token = await FirebaseMessaging().getToken();
        if( token == "" && !chef.active){
          //ready = false;
          subtitle = "It is recommended for you to enable notifications so you are alerted when a request is made. Do you want to be active anyways?";
          //await NotificationFunctions().enableNotifications(chef, userId);
        }
          showPlatformDialog(
            context: context, 
            builder: (_) => PlatformAlertDialog(
              title: Text('Active'),
              content: Text(subtitle),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text('Cancel'), 
                  onPressed: () => Navigator.pop(context)
                ),
                if(ready)(
                PlatformDialogAction(
                  child: Text('OK'), 
                  onPressed: () { 
                    ChefFunctions().toggleActive(chef);
                    Navigator.pop(context);
                  }
                )
                )
              ],
            )
          );
      },
          child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(3),
          color: chef.active ? Colors.tealAccent[400] : Colors.red[400],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0),
          child: Text((chef.active ? 'Active' : 'Inactive')),
        ),
      ),
    );
  }
}

class ChefPic extends StatefulWidget {
  const ChefPic({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  _ChefPicState createState() => _ChefPicState();
}

class _ChefPicState extends State<ChefPic> {
  Future<dynamic> profilePic;

  @override
  void initState() {
    profilePic = ImageFunctions().getImage(widget.chef.profileImage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await ImageSourceModal().showModal(context, 'chefProfile', widget.chef.id);
        profilePic = ImageFunctions().getImage(widget.chef.profileImage);
        this.setState(() {});
      },
      child: FutureBuilder<dynamic>(
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
                radius: 64,
                child: Text(
                    widget.chef.firstName.substring(0, 1) +
                        widget.chef.lastName.substring(0, 1),
                    style: TextStyle(fontSize: 60)),
              );
            }
          }),
    );
  }
}


