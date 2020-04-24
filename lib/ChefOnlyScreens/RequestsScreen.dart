import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Models/Order.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  Future<QuerySnapshot> requests;
  
  @override
  void initState() {
    requests = ChefFunctions().getRequestById(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<QuerySnapshot>(
      future: requests,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.documents.isNotEmpty) {
            return PlatformScaffold(
              appBar: PlatformAppBar(
                title: Text('Your Requests'),
              ),
              body: ListView.separated(
                itemBuilder: (context, index) {
                  Order request = Order.fromFirestore(snapshot.data.documents[index]);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height*.125 + height*(.05*request.meals.length),
                          child: Column(
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
                                primary: false,
                                shrinkWrap: true,
                                itemCount: request.meals.length,
                                itemBuilder: (context, index) {
                                  Map<dynamic, dynamic> meal = request.meals[index];
                                  return Container(
                                    height: height*.05,
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
                                    onPressed: null,
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
                                    onPressed: null,
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
                itemCount: snapshot.data.documents.length
              ),
            );
          } else {
            return PlatformScaffold(
              appBar: PlatformAppBar(title: Text('Your Requets')),
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
