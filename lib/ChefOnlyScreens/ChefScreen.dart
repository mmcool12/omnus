import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/ChefOnlyScreens/ActiveRequestsScreen.dart';
import 'package:omnus/ChefOnlyScreens/ChefEditScreenNew.dart';
import 'package:omnus/ChefOnlyScreens/PastRequestsScreen.dart';
import 'package:omnus/Firestore/ChefFunctions.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class ChefScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    if (user != null) {
      if (user.chefId.isEmpty) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Become A Chef',
              style: TextStyle(color: Colors.black),
            ),
            ios: (_) =>
                CupertinoNavigationBarData(transitionBetweenRoutes: false),
          ),
          body: Center(
            child: FlatButton(
                color: Colors.tealAccent[400],
                onPressed: () async {
                  await ChefFunctions().createChef(user).then((id) =>
                      Navigator.push(
                          context,
                          platformPageRoute(
                              context: context,
                              builder: (BuildContext context) =>
                                  ChefEditScreenNew(chefId: id))));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Become A Chef'),
                )),
          ),
        );
      } else {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Chef Dashboard',
              style: TextStyle(color: Colors.black),
            ),
            ios: (_) =>
                CupertinoNavigationBarData(transitionBetweenRoutes: false),
          ),
          body: Column(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                    context, 
                    platformPageRoute(context: context, builder: (BuildContext context) => ChefEditScreenNew(chefId: user.chefId))
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(width: 1.0, color: const Color(0x12707070)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x1a000000),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                      ],
                    ),
                    child: Center(child: Text('Chef Profile')),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                    context, 
                    platformPageRoute(context: context, builder: (BuildContext context) => ActiveRequestsScreen(chefId: user.chefId))
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(width: 1.0, color: const Color(0x12707070)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x1a000000),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                      ],
                    ),
                    child: Center(child: Text('Active Requests')),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                    context, 
                    platformPageRoute(context: context, builder: (BuildContext context) => PastRequestsScreen(chefId: user.chefId))
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border:
                          Border.all(width: 1.0, color: const Color(0x12707070)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x1a000000),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                      ],
                    ),
                    child: Center(child: Text('Past Requests')),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Center(child: PlatformCircularProgressIndicator());
    }
  }
}
