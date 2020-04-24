import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/Models/Order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<QuerySnapshot> orders;
  
  @override
  void initState() {
    orders = UserFunctions().getOrdersById(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<QuerySnapshot>(
      future: orders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.documents.isNotEmpty) {
            List<DocumentSnapshot> active = snapshot.data.documents.where((test) => test.data['completed'] != true).toList();
            List<DocumentSnapshot> completed = snapshot.data.documents.where((test) => test.data['completed'] == true).toList();
            return PlatformScaffold(
              iosContentPadding: true,
              appBar: PlatformAppBar(
                title: Text('Your Orders'),
              ),
              body: SingleChildScrollView(
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
                    ActiveList(active: active, height: height),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16,8,0,0),
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
            );
          } else {
            return PlatformScaffold(
              appBar: PlatformAppBar(title: Text('Your Orders')),
              body: Center(child: Text('No orders')),
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
  }) : super(key: key);

  final List<DocumentSnapshot> active;
  final double height;

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
                  height: height*.075 + height*(.04*request.meals.length),
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
                            height: height*.04,
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
                        (request.accepted ? 'Accepted' : 'Not yet accepted'),
                        style: TextStyle(
                          fontSize: 22,
                          color: (request.accepted ? Colors.green : Colors.black),
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
                  height: height*.075 + height*(.04*request.meals.length),
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
                            height: height*.04,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            (request.accepted ? 'Completed' : 'Cancelled'),
                            style: TextStyle(
                              fontSize: 22,
                              color: (request.accepted ? Colors.green : Colors.red)
                            ),
                          ),
                          if(request.accepted)
                          GestureDetector(
                            onTap: null,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Leave a review',
                                  style: TextStyle(
                                fontSize: 20,
                              ),
                                ),
                                Icon(
                                  CupertinoIcons.pencil,
                                  size: 25,
                                )
                              ],
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
