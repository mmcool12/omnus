import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Message.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class MessagingScreen extends StatefulWidget{
  final Chat chat;

  MessagingScreen({
    Key key,
    @required this.chat
  }) : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final List<String> messages  = ["Hello", "hello", "Whoa this is really cool", "I am a big fan",
  "Hello", "hello", "Whoa this is really cool","Hello", "hello", "Whoa this is really cool", "I am a big fan",
  "Hello", "hello", "Whoa this is really cool","Hello", "hello", "Whoa this is really cool", "I am a big fan",
  "Hello", "hello", "Whoa this is really cool"];

  @override
  Widget build(BuildContext context) {
    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    final textController = TextEditingController();

    void sendMessage(){
      if(textController.text != "") {
        ChatFunctions().createMessage(widget.chat.id, user.id, textController.text);
        textController.clear();
      }
    }

    @override
    void dispose() {
      textController.dispose();
      super.dispose();
    }

    Widget listview(List<Message> messages) {
      return ListView.separated(
        reverse: true,
          controller: ScrollController(
            initialScrollOffset: 20
          ),
            separatorBuilder: (context, index) {
                return Padding(padding: EdgeInsets.symmetric(vertical: 2.0));
            },
            itemCount: messages.length,
            itemBuilder: (context, index){
              Message message = messages[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
        alignment: message.sender == user.id ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width*.65
          ),
          color: Colors.transparent,
          child: Bubble(
            radius: Radius.circular(25),
            nipRadius: 3,
            nipOffset: 5,
            color: message.sender == user.id ? Colors.blueAccent : Colors.blueGrey,
            nip: message.sender == user.id ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
              ),
            )
          ),
        ),
                  ),
                );
            },
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.chefName, style: TextStyle(color: Colors.black)),
<<<<<<< HEAD
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
=======
>>>>>>> 3b51d1a9c32b2868f9ca254c45fda49675e9c1d6
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: ChatFunctions().getChatStream(widget.chat.id),
              builder: (context, snapshot) {
                List<Message> messages = [];
                if(snapshot.hasData && snapshot.data.exists){
                for (Map<dynamic, dynamic> snap in snapshot.data['messages']) messages.add(Message.fromMap(snap));
                  return listview(messages.reversed.toList());
                } else{
                  return Text('Loading');
                }
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(Icons.image),
              title: TextField(
                controller: textController,
                onSubmitted: (string) =>  sendMessage(),
              ),
              trailing: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => sendMessage(),
              ),
            ),
          ),
        ],
      )
    );
  }
}