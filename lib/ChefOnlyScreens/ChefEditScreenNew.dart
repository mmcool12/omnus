import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Components/EditBioTagModal.dart';
import 'package:omnus/Components/ImageHeader.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Components/MenuTiles.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';

class ChefEditScreenNew extends StatefulWidget {
  final String chefId;

  @override
  ChefEditScreenNew({
    Key key,
    @required this.chefId,
  }) : super(key: key);

  @override
  _ChefEditScreenNewState createState() => _ChefEditScreenNewState();
}

class _ChefEditScreenNewState extends State<ChefEditScreenNew> {
  Future<List<dynamic>> getImages;
  Stream<DocumentSnapshot> stream;
  Chef chef;

  @override
  void initState() {
    stream = ChefFunctions().getChefStreamById(widget.chefId);
    getImages = ImageFunctions().getChefsImagesFromID(widget.chefId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<DocumentSnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: PlatformCircularProgressIndicator());
        } else {
        chef = Chef.fromFirestore(snapshot.data);
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
                          chef: chef,
                          getImages: getImages,
                          edit: true,
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
                                ChefPic(chef: chef),
                                const SizedBox(width: 12.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          chef.tags.isEmpty ? "Add a tag" :  chef.tags[0],
                                          style: const TextStyle(
                                              fontFamily: 'Apple SD Gothic Neo',
                                              fontSize: 22,
                                              color: const Color(0xff8e8e8e),
                                              letterSpacing: 0.255,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        GFRating(
                                          itemCount: 5,
                                          value: chef.rating,
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
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () async => await EditBioTagModal().showModal(context, chef),
                                          child: Icon(PlatformIcons(context).create)
                                        )
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
                                              chef.bio.length == 0 ? "Add a bio" : chef.bio,
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
                          MenuTiles(chef: chef, edit: true),
                          const SizedBox(height: kBottomNavigationBarHeight+ 32)
                        ],
                      ),
                    )
                  ]),
            ],
          ),
        );
        }
      }
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
                placeholder: (context, url) => SizedBox(height: 96, width: 96, child: Center(child: PlatformCircularProgressIndicator())),
                imageBuilder: (context, imageProvider) => 
                Container(
                  height: 96, //64*2
                  width: 96,
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
                radius: 48,
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
