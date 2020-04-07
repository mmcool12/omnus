import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/MainScreens/MessagingScreen.dart';
import 'package:omnus/Models/Chat.dart';

class ChatScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages')
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ChatFunctions().getChats(),
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
                        MaterialPageRoute(builder: (context) => MessagingScreen())),
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