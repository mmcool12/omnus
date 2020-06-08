import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ChatFunctions.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/OrderFunctions.dart';
import 'package:omnus/Models/Chat.dart';
import 'package:omnus/Models/Order.dart';
import 'package:omnus/SharedScreens/MessagingScreen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key key, this.chefId}) : super(key: key);
  final String chefId;

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  Future<QuerySnapshot> requests;
  
  @override
  void initState() {
    requests = ChefFunctions().getRequestById(widget.chefId);
    super.initState();
  }

  refresh(){
    requests = ChefFunctions().getRequestById(widget.chefId);
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<QuerySnapshot>(
      future: requests,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.documents.isNotEmpty) {
            List<DocumentSnapshot> newlist = snapshot.data.documents.where((test) => test.data['accepted'] == false && test.data['completed'] == false).toList();
            List<DocumentSnapshot> active = snapshot.data.documents.where((test) => test.data['accepted'] == true && test.data['completed'] == false).toList();
            List<DocumentSnapshot> completed = snapshot.data.documents.where((test) => test.data['completed'] == true).toList();
            return PlatformScaffold(
              iosContentPadding: true,
              appBar: PlatformAppBar(
                title: Text('Your Requests'),
              ),
              body: SingleChildScrollView(
                primary: true,
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16,8,0,0),
                        child: Text(
                          'Active',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ActiveList(active: active, height: height, id: widget.chefId, refresh: refresh),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16,12,0,0),
                        child: Text(
                          'New',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      NewList(newlist: newlist, height: height, refresh: refresh),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16,12,0,0),
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      CompletedList(completed: completed, height: height),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return PlatformScaffold(
              appBar: PlatformAppBar(title: Text('Your Requests')),
              body: Center(child: Text('No active requests')),
            );
          }
        } else {
          return PlatformScaffold(
            body: Center(child: PlatformCircularProgressIndicator()),
          );
        } 
      }
    );
  }
}

class ActiveList extends StatelessWidget {
  const ActiveList({
    Key key,
    @required this.active,
    @required this.height,
    @required this.id,
    @required this.refresh,
  }) : super(key: key);

  final List<DocumentSnapshot> active;
  final double height;
  final String id;
  final dynamic refresh;

  @override
  Widget build(BuildContext context) {
    if (active.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        itemBuilder: (context, index) {
          Order request = Order.fromFirestore(active[index]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 120 + (32.0 * request.meals.length),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                (request.accepted ? request.buyerName : 'New order'),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 4),
                              ListView.builder(
                                padding: const EdgeInsets.all(0),
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: request.meals.length,
                                itemBuilder: (context, index) {
                                  Map<dynamic, dynamic> meal = request.meals[index];
                                  return Container(
                                    height: 32,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${meal['quantity']}x',
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                        ),
                                        Text('  '),
                                        Text(
                                          meal['name'],
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Total Price',
                                    style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${request.price}',
                                    style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton.icon(
                                    icon: Icon(
                                      PlatformIcons(context).checkMarkCircledSolid,
                                      color: Colors.blueAccent,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      await OrderFunctions().completeOrder(request.id);
                                      refresh();
                                      },
                                    label: Text(
                                      'Complete',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                      ),
                                    ),
                                  ),
                                  FlatButton.icon(
                                    icon: Icon(
                                      PlatformIcons(context).create,
                                      color: Colors.blueAccent,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                        Chat chat;
                                        await ChatFunctions()
                                            .createChatFromOrder(request.buyerId, request.buyerName, request.chefId, request.chefName)
                                            .then((result) =>
                                                chat = Chat.fromFirestore(result));
                                        return Navigator.push(
                                            context,
                                            platformPageRoute(
                                                builder: (context) =>
                                                    MessagingScreen(chat: chat, id: id, type: 'chef'), context: context));
                                      },
                                    label: Text(
                                      'Message',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
          );
        }, 
        separatorBuilder: (context, index) {
          return SizedBox(height: 4);
        }, 
        itemCount: active.length
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('No active orders')),
      );
    }
  }
}

class NewList extends StatelessWidget {
  const NewList({
    Key key,
    @required this.newlist,
    @required this.height,
    @required this.refresh,
  }) : super(key: key);

  final List<DocumentSnapshot> newlist;
  final double height;
  final dynamic refresh;

  @override
  Widget build(BuildContext context) {
    if (newlist.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        itemBuilder: (context, index) {
          Order request = Order.fromFirestore(newlist[index]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 120 + (32.0 * request.meals.length),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                (request.accepted ? request.buyerName : 'New order'),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 4),
                              ListView.builder(
                                padding:const EdgeInsets.all(0),
                                primary: false,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: request.meals.length,
                                itemBuilder: (context, index) {
                                  Map<dynamic, dynamic> meal = request.meals[index];
                                  return Container(
                                    height: 32,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${meal['quantity']}x',
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                        ),
                                        Text('  '),
                                        Text(
                                          meal['name'],
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Total Price',
                                    style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${request.price}',
                                    style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton.icon(
                                    icon: Icon(
                                      PlatformIcons(context).checkMarkCircledSolid,
                                      color: Colors.lightGreen,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      await OrderFunctions().acceptOrder(request.id);
                                      refresh();
                                    },
                                    label: Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                      ),
                                    ),
                                  ),
                                  FlatButton.icon(
                                    icon: Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      await OrderFunctions().rejectOrder(request.id);
                                      refresh();
                                    },
                                    label: Text(
                                      'Reject',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
          );
        }, 
        separatorBuilder: (context, index) {
          return SizedBox(height: 4);
        }, 
        itemCount: newlist.length
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('No active orders')),
      );
    }
  }
}

class CompletedList extends StatelessWidget {
  const CompletedList({
    Key key,
    @required this.completed,
    @required this.height,
  }) : super(key: key);

  final List<DocumentSnapshot> completed;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (completed.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        itemBuilder: (context, index) {
          Order request = Order.fromFirestore(completed[index]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 72 + (32.0 * request.meals.length),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Text(
                      //   (request.id ? request.buyerName : 'New order'),
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold
                      //   ),
                      // ),
                      //SizedBox(height: 4),
                      ListView.builder(
                        padding: const EdgeInsets.all(0),
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: request.meals.length,
                        itemBuilder: (context, index) {
                          Map<dynamic, dynamic> meal = request.meals[index];
                          return Container(
                            height: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${meal['quantity']}x',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                Text('  '),
                                Text(
                                  meal['name'],
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total Price',
                            style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${request.price}',
                            style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        (request.accepted ? 'Completed' : 'Cancelled'),
                        style: TextStyle(
                          fontSize: 22,
                          color: (request.accepted ? Colors.green : Colors.red)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }, 
        separatorBuilder: (context, index) {
          return SizedBox(height: 4);
        }, 
        itemCount: completed.length
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('No completed orders')),
      );
    }
  }
}
