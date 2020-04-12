import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/SharedScreens/MessagingScreen.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  
  ChatScreen({Key key, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Messages', style: TextStyle(color: Colors.black)),
        ios: (_) => CupertinoNavigationBarData(transitionBetweenRoutes: false),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: ChatFunctions().getUsersChats(user.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.isEmpty) {
                return Center(child: Text('No messages'));
              } else {
                List<Chat> chats = [];
                for (DocumentSnapshot snap in snapshot.data.documents)
                  chats.add(Chat.fromFirestore(snap));
                return ListView.separated(
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
                          child: Text('delete',style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                        child: Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                            ),
                            onTap: () => Navigator.push(
                                context,
                                platformPageRoute(
                                    builder: (context) => MessagingScreen(
                                        chat: chats[index], user: user),
                                    context: context)),
                            title: Text(chats[index].chefName ?? "help"),
                          ),
                        ),
                        key: Key(chats[index].chefId),
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(child: Text('Loading'));
            }
          }),
    );
  }
}
