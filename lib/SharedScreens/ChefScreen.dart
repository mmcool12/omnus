import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class ChefScreen extends StatelessWidget {
  final User user;

  const ChefScreen({
      Key key,
      @required this.user
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    Chef chef;
    if (snapshot != null) {
      if (snapshot.data != null) {
        chef = Chef.fromFirestore(snapshot);
      }
    }


    if (user.chefId != null) {
      if(chef != null){
        return Scaffold(
          appBar: AppBar(
            title: Text('Chef, ${chef.lastName}'),
          ),
          body: Center(
              child: SizedBox(
                width: 300,
                height: 100,
            child: FlatButton(
                color: Colors.blue,
                onPressed: () => null,
                child: Text('Congrats on being a chef')),
          )),
        );
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Loading')),
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Become a chef today'),
        ),
        body: Center(
            child: SizedBox(
              width: 300,
              height: 100,
          child: FlatButton(
              color: Colors.blue,
              onPressed: () => UserFunctions().createChef(user ?? null),
              child: Text('Click here to create chef profile')),
        )),
      );
    }
  }
}
