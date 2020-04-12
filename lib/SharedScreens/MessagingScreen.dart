import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Message.dart';
import 'package:omnus/Models/User.dart';

class MessagingScreen extends StatefulWidget {
  final Chat chat;
  final User user;

  MessagingScreen({Key key, @required this.chat, @required this.user})
      : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    final textController = TextEditingController();

    void sendMessage() {
      if (textController.text != "") {
        ChatFunctions()
            .createMessage(widget.chat.id, widget.user.id, textController.text);
        textController.clear();
      }
    }

    Widget listview(List<Message> messages) {
      return ListView.separated(
        reverse: true,
        controller: ScrollController(initialScrollOffset: 20),
        separatorBuilder: (context, index) {
          return Padding(padding: EdgeInsets.symmetric(vertical: 2.0));
        },
        itemCount: messages.length,
        itemBuilder: (context, index) {
          Message message = messages[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: message.sender == widget.user.id
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(maxWidth: width * .65),
                color: Colors.transparent,
                child: Bubble(
                    radius: Radius.circular(25),
                    nipRadius: 3,
                    nipOffset: 5,
                    color: message.sender == widget.user.id
                        ? Colors.blueAccent
                        : Colors.blueGrey,
                    nip: message.sender == widget.user.id
                        ? BubbleNip.rightBottom
                        : BubbleNip.leftBottom,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        message.message,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
            ),
          );
        },
      );
    }

    return PlatformScaffold(
        appBar: PlatformAppBar(
          title:
              Text(widget.chat.chefName, style: TextStyle(color: Colors.black)),
                      ios: (_) => CupertinoNavigationBarData(transitionBetweenRoutes: false),

        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: ChatFunctions().getChatStream(widget.chat.id),
                builder: (context, snapshot) {
                  List<Message> messages = [];
                  if (snapshot.hasData && snapshot.data.exists) {
                    for (Map<dynamic, dynamic> snap in snapshot
                        .data['messages']) messages.add(Message.fromMap(snap));
                    return listview(messages.reversed.toList());
                  } else {
                    return Text('Loading');
                  }
                },
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Material(
                              child: ListTile(
                  leading: Icon(Icons.image),
                  title: PlatformTextField(
                    controller: textController,
                    onSubmitted: (string) => sendMessage(),
                    ios: (_) => CupertinoTextFieldData(
                      
                    ),
                  ),
                  trailing: PlatformIconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => sendMessage(),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
