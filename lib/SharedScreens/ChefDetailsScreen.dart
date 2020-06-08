import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/CartButton.dart';
import 'package:omnus/Components/ImageHeader.dart';
import 'package:omnus/Components/MenuTiles.dart';
import 'package:omnus/Components/ReviewTiles.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class ChefDetailsScreen extends StatefulWidget {
  final Chef chef;
  final User user;

  @override
  ChefDetailsScreen({
    Key key,
    @required this.chef,
    @required this.user,
  }) : super(key: key);

  @override
  _ChefDetailsScreenState createState() => _ChefDetailsScreenState();
}

class _ChefDetailsScreenState extends State<ChefDetailsScreen> {
  Future<List<dynamic>> getImages;

  @override
  void initState() {
    getImages = ImageFunctions().getChefsImages(widget.chef.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return PlatformScaffold(
      iosContentPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverPersistentHeader(
                  delegate: ImageHeader(
                      height: height,
                      chef: widget.chef,
                      getImages: getImages,
                      edit: false,
                      user: widget.user,
                      ),
                  pinned: true,
                  floating: false,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            ProfilePic(chef: widget.chef),
                            const SizedBox(width: 12.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'American',
                                      style: const TextStyle(
                                          fontFamily: 'Apple SD Gothic Neo',
                                          fontSize: 24,
                                          color: const Color(0xff8e8e8e),
                                          letterSpacing: 0.255,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 8),
                                    GFRating(
                                      itemCount: 5,
                                      value: widget.chef.rating,
                                      size: 22,
                                      color: Colors.amber,
                                      borderColor: Colors.grey,
                                      defaultIcon: GFRating(
                                        size: 22,
                                        itemCount: 1,
                                        value: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              .6,
                                      child: Text(
                                          'There are days which occur in this climate, at almost any season of the year, in the world.',
                                          maxLines: 3 ,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Apple SD Gothic Neo',
                                            fontSize: 14,
                                            color: const Color(0xff393838),
                                          ),
                                          textAlign: TextAlign.start),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      MenuTiles(chef: widget.chef, edit: false),
                      ReviewTile(chef: widget.chef),
                      const SizedBox(height: kBottomNavigationBarHeight+ 32)
                    ],
                  ),
                )
              ]),
          Consumer<Cart>(
            builder: (BuildContext context, Cart value, Widget child) {
              return CartButton(
                  cart: value, padding: false, buyer: widget.user);
            },
          )
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
              placeholder: (context, url) => SizedBox(
                  height: 96,
                  width: 96,
                  child: Center(child: PlatformCircularProgressIndicator())),
              imageBuilder: (context, imageProvider) => Container(
                height: 96, //48*2
                width: 96,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
            );
          } else {
            return GFAvatar(
              backgroundColor: Colors.blueAccent[400],
              radius: 48,
              child: Text(
                  widget.chef.firstName.substring(0, 1) +
                      widget.chef.lastName.substring(0, 1),
                  style: TextStyle(fontSize: 48)),
            );
          }
        });
  }
}
