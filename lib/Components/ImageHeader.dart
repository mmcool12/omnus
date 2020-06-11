import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/ImageList.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/SharedScreens/MessagingScreen.dart';

class ImageHeader extends SliverPersistentHeaderDelegate {
  ImageHeader(
      {@required this.height,
      @required this.chef,
      this.edit,
      @required this.getImages,
      this.user});

  final double height;
  final Chef chef;
  final bool edit;
  Future<List<dynamic>> getImages;
  final User user;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = shrinkOffset / (maxExtent + 1);
    double width = MediaQuery.of(context).size.width;
    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          FutureBuilder<List<dynamic>>(
              future: getImages,
              builder: (context, snapshot) {
                if (!snapshot.hasData &&
                    snapshot.connectionState != ConnectionState.done) {
                  return Container(
                      height: height * .2,
                      child:
                          Center(child: PlatformCircularProgressIndicator()));
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Center(child: Text('Error'));
                } else {
                  List<dynamic> images = snapshot.data;
                  if (edit) {
                    if (images.length == 0) {
                      images.add('create');
                    } else if (images[images.length - 1] != 'create') {
                      images.add('create');
                    }
                  }
                  return Container(
                    color: Colors.black,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          if (images[index] == 'create') {
                            return GestureDetector(
                              onTap: () async {
                                await ImageSourceModal()
                                    .showModal(context, 'chef', chef.id);
                                getImages = ImageFunctions()
                                    .getChefsImages(chef.images);
                              },
                              child: Container(
                                color: Colors.grey[350],
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(PlatformIcons(context).add,
                                          color: Colors.white, size: 40),
                                      Text(
                                        'Add Image',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // if(images != null) {
                            //   if(widget.edit && images.length-1 != widget.chef.images.length && images[images.length-1] != 'new'){
                            //     images.removeAt(images.length-1);
                            //     images.add('new');
                            //   }
                            // }
                            return Center(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black,
                                  child: ImageList(
                                      height: height, chef: chef, edit: edit)),
                            );
                          }
                        }),
                  );
                }
              }),
          Positioned(
              top: 22,
              left: 56,
              child: SafeArea(
                child: Text(
                  chef.name,
                  style: TextStyle(
                    fontFamily: 'Acumin Pro',
                    fontSize: 20,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
              )),
          fadeOpacity('in', opacity,
              Persistent(width: width, height: height, chef: chef)),
          Positioned(
            top: opacity > .75 ? window.viewPadding.top > 75 ? -4 : -8 : 0,
            left: -16,
            child: SafeArea(
              child: PlatformIconButton(
                icon: Icon(
                  PlatformIcons(context).back,
                  color: opacity > .75 ? Colors.black : Colors.white,
                  size: 36,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
              top: opacity > .75 ? window.viewPadding.top > 75 ? 8 : 12 : 22,
              right: 8,
              child: SafeArea(
                child: (edit ? 
                ActiveToggle(chef: chef)
                : 
                PlatformIconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: opacity > .75 ? Colors.black : Colors.white,
                    size: 32,
                  ),
                  onPressed: () async {
                          Chat chat;
                          await ChatFunctions().createChat(user, chef).then(
                              (result) => chat = Chat.fromFirestore(result));
                          return Navigator.push(
                              context,
                              platformPageRoute(
                                  builder: (context) => MessagingScreen(
                                      chat: chat, id: user.id, type: 'user'),
                                  context: context));
                        })
                ),
              )),
        ],
      ),
    );
  }

  @override
  double get maxExtent => (height / 3);

  @override
  double get minExtent => (height / 9);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  Widget fadeOpacity(String direction, double opacity, Widget child) {
    double fadeOpactity = 0;
    if (direction == 'in') {
      fadeOpactity = opacity;
    } else {
      fadeOpactity = 1 - opacity;
    }

    return Opacity(
      opacity: fadeOpactity > .75 ? 1 : 0,
      child: child,
    );
  }
}

class Persistent extends StatelessWidget {
  const Persistent({
    Key key,
    @required this.width,
    @required this.height,
    @required this.chef,
  }) : super(key: key);

  final double height;
  final double width;
  final Chef chef;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
        width: width,
        height: height / 9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(width: 48),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ' ${chef.name}',
                  style: TextStyle(
                    fontFamily: 'Acumin Pro',
                    fontSize: 24,
                    color: const Color(0xff525252),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                GFRating(
                  itemCount: 5,
                  value: chef.rating,
                  size: 24,
                  color: Colors.amber,
                  borderColor: Colors.grey,
                  defaultIcon: GFRating(
                    size: 24,
                    itemCount: 1,
                    value: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4)
              ],
            ),
          ],
        ));
  }
}

class ActiveToggle extends StatelessWidget {
  const ActiveToggle({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var ready = true;
          var subtitle =
              'This means that people will be able to see and search for you are you ready?';

          if (chef.menu.length > 1 &&
              chef.images.length > 1 &&
              chef.profileImage == "") {
            subtitle = 'Add picture but okay';
          }
          if (chef.menu.length == 0 && chef.images.length == 0) {
            ready = false;
            subtitle = 'Must add menu item and picture to be active';
          }
          if (chef.active) {
            subtitle = "This means you will no longer get order request";
          }
          await showPlatformDialog(
              context: context,
              builder: (_) => PlatformAlertDialog(
                    title: Text('Active'),
                    content: Text(subtitle),
                    actions: <Widget>[
                      PlatformDialogAction(
                          child: Text('Cancel'),
                          onPressed: () async => Navigator.pop(_)),
                      if (ready)
                        (PlatformDialogAction(
                            child: Text('OK'),
                            onPressed: () async {
                              await ChefFunctions().toggleActive(chef);
                              Navigator.pop(_);
                            }))
                    ],
                  ));
        },
        child: Material(
          color: Colors.transparent,
          child: Text(
            chef.active ? 'Active' : 'Hidden',
            style: TextStyle(
                    fontFamily: 'Acumin Pro',
                    fontSize: 20,
                    color: chef.active ? Colors.tealAccent: Colors.redAccent,
                    fontWeight: FontWeight.w900,
                  ),
          )
        ));
  }
}
