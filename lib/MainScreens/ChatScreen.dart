import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/MainScreens/MessagingScreen.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('Messages', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
=======
        title: Text('Messages',style: TextStyle(color: Colors.black)),
>>>>>>> 3b51d1a9c32b2868f9ca254c45fda49675e9c1d6
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ChatFunctions().getUsersChats(user.id),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if (snapshot.data.documents.isEmpty){
              return Center(child: Text('No messages'));
            } else {
              List<Chat> chats = [];
              for (DocumentSnapshot snap in snapshot.data.documents) chats.add(Chat.fromFirestore(snap));
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
                itemCount: chats.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onTap: () => Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => MessagingScreen(chat: chats[index]))),
                      title: Text(chats[index].chefName ?? "help"),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: Text('Loading'));
          }
        }
      ),
    );
  }
}