import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/ChefOnlyScreens/ChefEditScreen.dart';
import 'package:omnus/ChefOnlyScreens/RequestsScreen.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/SharedScreens/OrdersScreen.dart';
import 'package:provider/provider.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user;

    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    if (user == null) {
      print(user.profileImage);
      return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(
            'Loading',
            style: TextStyle(color: Colors.black),
          ),
          ios: (_) =>
              CupertinoNavigationBarData(transitionBetweenRoutes: false),
        ),
      );
    } else {
      return PlatformScaffold(
        iosContentPadding: true,
        appBar: PlatformAppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          ios: (_) =>
              CupertinoNavigationBarData(transitionBetweenRoutes: false),
          trailingActions: <Widget>[
            FlatButton(
                onPressed: () async {
                  await AuthFunctions().signOut().then((onValue) {
                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                  });
                },
                child: Text('Sign out'))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ProfilePic(user: user),
                    Expanded(
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 35,
                            ),
                          ),
                          FlatButton(
                              color: Colors.blueAccent[400],
                              onPressed: () async {
                                if (user.chefId == "") {
                                  await ChefFunctions().createChef(user).then(
                                      (id) => Navigator.push(
                                          context,
                                          platformPageRoute(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  ChefEditScreen(chefId: id))));
                                } else {
                                  Navigator.push(
                                      context,
                                      platformPageRoute(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ChefEditScreen(
                                                  chefId: user.chefId)));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (user.chefId == ""
                                    ? 'Become a chef!'
                                    : 'Your chef profile'),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                              ))
                        ],
                      )),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              
              Container(height: 1, color: Colors.black),
              SettingsTile(
                title: 'Orders',
                leading: Icon(Icons.fastfood),
                onTap: () => Navigator.push(context, 
                  platformPageRoute(context: context, builder: (context) => OrdersScreen(id: user.id))),
                top: true,
              ),
              if(user.chefId != "")
              SettingsTile(
                title: 'Requests',
                leading: Icon(Icons.error),
                onTap: () => Navigator.push(context, 
                  platformPageRoute(context: context, builder: (context) => RequestsScreen(chefId: user.chefId))),
                bottom: true,
              ),
            ],
          ),
        ),
      );
    }
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget leading;
  final onTap;
  final bool top;
  final bool bottom;

  const SettingsTile({
    Key key,
    @required this.title,
    @required this.onTap,
    this.leading,
    this.top,
    this.bottom
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0)),
          color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await ImageSourceModal().showModal(context, 'userProfile', widget.user.id);
        print('hello');
        profilePic = ImageFunctions().getImage(widget.user.profileImage);
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
                    widget.user.firstName.substring(0, 1) +
                        widget.user.lastName.substring(0, 1),
                    style: TextStyle(fontSize: 65)),
              );
            }
          }),
    );
  }

}
