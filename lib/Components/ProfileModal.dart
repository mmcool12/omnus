import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/User.dart';

class ProfileModal {
  showModal(BuildContext context, User user) async {
    showPlatformModalSheet(
      context: context,
      builder: (context) => PlatformWidget(
          android: (context) => androidModal(context, user),
          ios: (context) => iphoneModal(context, user)),
    );
  }

  Widget androidModal(BuildContext context, User user) {
    var type = "";
    var id = "";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: MediaQuery.of(context).size.height * .75,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              child: InkWell(
                onTap: () async {
                  if (type == 'userProfile') {
                    await ImageFunctions()
                        .pickThenUploadProfile(ImageSource.camera, id);
                    Navigator.pop(context);
                  } else if (type == 'chef') {
                    await ImageFunctions()
                        .pickThenUploadProfile(ImageSource.camera, id);
                    Navigator.pop(context);
                  }
                },
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Image from Camera'),
                ),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () async {
                  if (type == 'userProfile') {
                    await ImageFunctions()
                        .pickThenUploadProfile(ImageSource.gallery, id)
                        .then((result) => Navigator.pop(context));
                  } else if (type == 'chef') {
                    await ImageFunctions()
                        .pickThenUploadChefImage(ImageSource.gallery, id)
                        .then((result) => Navigator.pop(context));
                  }
                },
                child: ListTile(
                  leading: Icon(Icons.photo_size_select_actual),
                  title: Text('Image from Photos'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iphoneModal(BuildContext context, User user) {
    return Container(
      height: MediaQuery.of(context).size.height * .95,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0),
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ))),
          ),
          SizedBox(height: 8),
          ProfilePic(user: user),
          SizedBox(height: 4),
          Text(
            user.name,
            maxLines: 1,
            style: GoogleFonts.montserrat(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 30),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () async {
                await AuthFunctions().signOut().then((onValue) {
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                });
              },
              child: Text(
                'LOGOUT',
                maxLines: 1,
                style: GoogleFonts.montserrat(
                    color: Colors.tealAccent[400],
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget leading;
  final onTap;
  final bool top;
  final bool bottom;

  const SettingsTile(
      {Key key,
      @required this.title,
      @required this.onTap,
      this.leading,
      this.top,
      this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0)), color: Colors.white),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          leading: this.leading,
          title: Text(this.title),
          trailing: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Future<dynamic> profilePic;

  @override
  void initState() {
    profilePic = ImageFunctions().getImage(widget.user.profileImage);

    super.initState();
  }

  final double size = 72;

  @override
  Widget build(BuildContext context) {
    String initials = "";
    initials += widget.user.firstName == null
        ? ""
        : widget.user.firstName.substring(0, 1);
    initials += widget.user.lastName == null
        ? ""
        : widget.user.lastName.substring(0, 1);

    return GestureDetector(
      onTap: () async {
        await ImageSourceModal()
            .showModal(context, 'userProfile', widget.user.id);
        print('hello');
        profilePic = ImageFunctions().getImage(widget.user.profileImage);
        this.setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: (size * 2) + 12,
            width: (size * 2) + 12,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.tealAccent),
                borderRadius: BorderRadius.all(Radius.circular(size + 12))),
          ),
          FutureBuilder<dynamic>(
              future: this.profilePic,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data ?? null,
                    placeholder: (context, url) => SizedBox(
                        height: size * 2,
                        width: size * 2,
                        child:
                            Center(child: PlatformCircularProgressIndicator())),
                    imageBuilder: (context, imageProvider) => Container(
                      height: size * 2,
                      width: size * 2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                  );
                } else {
                  return GFAvatar(
                    backgroundColor: Colors.blueAccent[400],
                    radius: size,
                    child: Text(initials, style: TextStyle(fontSize: size + 1)),
                  );
                }
              }),
        ],
      ),
    );
  }
}

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.teal[300], //Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
