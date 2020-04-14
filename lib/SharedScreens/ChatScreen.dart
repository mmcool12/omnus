import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/SharedScreens/MessagingScreen.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override

  String selected = "User";

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }


    return PlatformScaffold(
      iosContentPadding: true,
        appBar: PlatformAppBar(
          title: Text('Messages', style: TextStyle(color: Colors.black)),
          ios: (_) =>
              CupertinoNavigationBarData(transitionBetweenRoutes: false),
        ),
        body: (user.chefId == ""  ? UserMessages(user: user) :
        Column(  
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: height*.05,
              width: double.infinity,
              child: PlatformWidget(
                android: (_) => UserMessages(user: user),
                ios: (_) => CupertinoSlidingSegmentedControl(
                    groupValue: this.selected,
                    children: {
                      'User': Text('User Chats'),
                      'Chef': Text('Chef Chats')
                    },
                    onValueChanged: (string) {
                      this.setState(() => this.selected = string);
                      },
              ),
            ),
            ),
          ),
          IndexedStack(
            index: (this.selected == 'User' ? 0 : 1),
            children: <Widget>[
              UserMessages(user: user),
              ChefMessages(user: user)
            ],
          )
        ]
        )));
  }
}

getInititals(String name){
  String initials = name.substring(0, 1);
  int space = name.indexOf(" ");
  name = name.substring(space);
  return initials + name.trim().substring(0,1);

}

class UserMessages extends StatelessWidget {
  const UserMessages({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ChatFunctions().getUsersChats(user.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isEmpty) {
              return Center(child: Text('No messages'));
            } else {
              List<Chat> chats = [];
              for (DocumentSnapshot snap in snapshot.data.documents)
                chats.add(Chat.fromFirestore(snap));
              return Container(
                width: double.infinity,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                    );
                  },
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Dismissible(
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'delete',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: GFAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                    getInititals(chats[index].chefName),
                    style: TextStyle(fontSize: 25)),
              ),
                            onTap: () => Navigator.push(
                                context,
                                platformPageRoute(
                                    builder: (context) => MessagingScreen(
                                        chat: chats[index], user: user, type: 'user'),
                                    context: context)),
                            title: Text(chats[index].chefName ?? "help"),
                          ),
                        ),
                        key: Key(chats[index].chefId),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return Center(child: Text('Loading'));
          }
        });
  }
}

class ChefMessages extends StatelessWidget {
  const ChefMessages({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ChatFunctions().getChefsChats(user.chefId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isEmpty) {
              return Center(child: Text('No messages'));
            } else {
              List<Chat> chats = [];
              for (DocumentSnapshot snap in snapshot.data.documents)
                chats.add(Chat.fromFirestore(snap));
              return Container(
                width: double.infinity,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                    );
                  },
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Dismissible(
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'delete',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: GFAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                    getInititals(chats[index].buyerName),
                    style: TextStyle(fontSize: 25)),
              ),
                            onTap: () => Navigator.push(
                                context,
                                platformPageRoute(
                                    builder: (context) => MessagingScreen(
                                        chat: chats[index], user: user, type: 'chef'),
                                    context: context)),
                            title: Text(chats[index].buyerName),
                          ),
                        ),
                        key: Key(chats[index].chefId),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return Center(child: Text('Loading'));
          }
        });
  }
}
