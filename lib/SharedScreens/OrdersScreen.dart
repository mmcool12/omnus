import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/CreateReviewModal.dart';
import 'package:omnus/Firestore/OrderFunctions.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/Models/Order.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {

  refresh(){
    
  }

  @override
  Widget build(BuildContext context) {
    User user = User();

    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }
    double height = MediaQuery.of(context).size.height;
    if (user == null) {
      return Center(child: PlatformCircularProgressIndicator());
    } else {
      return FutureBuilder<QuerySnapshot>(
          future: UserFunctions().getOrdersById(user.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.isNotEmpty) {
                List<DocumentSnapshot> active = snapshot.data.documents
                    .where((test) => test.data['completed'] != true)
                    .toList();
                List<DocumentSnapshot> completed = snapshot.data.documents
                    .where((test) => test.data['completed'] == true)
                    .toList();
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
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                          child: Text(
                            'Active',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        ActiveList(active: active, height: height, refresh: refresh()),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                          child: Text(
                            'Completed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black),
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
          });
    }
  }
}

class ActiveList extends StatelessWidget {
  const ActiveList({
    Key key,
    @required this.active,
    @required this.height,
    @required this.refresh,
  }) : super(key: key);

  final List<DocumentSnapshot> active;
  final double height;
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
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text('  '),
                                    Text(
                                      meal['name'],
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              );
                            }),
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
                              (request.accepted
                                  ? 'Accepted'
                                  : 'Not yet accepted'),
                              style: TextStyle(
                                fontSize: 22,
                                color: (request.accepted
                                    ? Colors.green
                                    : Colors.black),
                              ),
                            ),
                            if (!request.accepted)
                              GestureDetector(
                                onTap: () async {
                                  await OrderFunctions()
                                      .cancelOrder(request.id);
                                  refresh();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Colors.red,
                                      size: 25,
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
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
          itemCount: active.length);
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
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text('  '),
                                    Text(
                                      meal['name'],
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              );
                            }),
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
                                  color: (request.accepted
                                      ? Colors.green
                                      : Colors.red)),
                            ),
                            if (request.accepted)
                              GestureDetector(
                                onTap: () async => CreateReviewModal()
                                    .showModal(context, request),
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
          itemCount: completed.length);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('No completed orders')),
      );
    }
  }
}
