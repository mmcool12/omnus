import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget{
  final List<String> messages  = ["Hello", "hello", "Whoa this is really cool", "I am a big fan",
  "Hello", "hello", "Whoa this is really cool","Hello", "hello", "Whoa this is really cool", "I am a big fan",
  "Hello", "hello", "Whoa this is really cool","Hello", "hello", "Whoa this is really cool", "I am a big fan",
  "Hello", "hello", "Whoa this is really cool"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chef Name')
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
        ),
        child: ListTile(
          leading: Icon(Icons.image),
          title: TextField(),
          trailing: Icon(Icons.send),
        ),
      ),
      body: Container(
        height: height*.8,
        color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
          controller: ScrollController(
            initialScrollOffset: 20
          ),
          reverse: true,
            separatorBuilder: (context, index) {
                return Padding(padding: EdgeInsets.symmetric(vertical: 2.0));
            },
            itemCount: messages.length,
            itemBuilder: (context, index){
                return Align(
        alignment: index.isEven ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: width*.6,
          color: Colors.blueAccent,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  messages[index],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
            )
          ),
        ),
                );
            },
          ),
              ),
      ),
    );
  }
}