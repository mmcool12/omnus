import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Models/Order.dart';

class PastRequestsScreen extends StatefulWidget {
  const PastRequestsScreen({Key key, this.chefId}) : super(key: key);
  final String chefId;

  @override
  _PastRequestsScreenState createState() => _PastRequestsScreenState();
}

class _PastRequestsScreenState extends State<PastRequestsScreen> {
  Future<QuerySnapshot> requests;
  
  @override
  void initState() {
    requests = ChefFunctions().getPastRequestById(widget.chefId);
    super.initState();
  }

  refresh(){
    requests = ChefFunctions().getPastRequestById(widget.chefId);
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
            List<DocumentSnapshot> requests = snapshot.data.documents;
            return PlatformScaffold(
              iosContentPadding: true,
              appBar: PlatformAppBar(
                title: Text('Past Requests'),
              ),
              body: SingleChildScrollView(
                primary: true,
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: CompletedList(completed: requests, height: height),
                ),
              ),
            );
          } else {
            return PlatformScaffold(
              appBar: PlatformAppBar(title: Text('Past Requests')),
              body: Center(child: Text('No past requests')),
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
        child: Center(child: Text('No past requests')),
      );
    }
  }
}
