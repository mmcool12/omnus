import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Components/SearchBar.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
//import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool searching = false;
  String query = "";
  Chef hey = new Chef(id: 'sjkjkd', rate: 6, name: 'yummy', menu: {});

  Future<List<Chef>> getChefs(String search) async {
    List<Chef> chefs = List<Chef>();
    await SearchFunctions().getAllChefs().then((result) => {
          for (DocumentSnapshot snap in result.documents)
            chefs.add(Chef.fromFirestore(snap))
        });

    return chefs;
  }

  void showChefPopup(BuildContext context, Chef chef){

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Dialog chefPopup = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Container(
          height: height * .4,
          width: width*.9,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(chef.name),
                FlatButton(
                  onPressed: null, 
                  child: Container(
                    color: Colors.blue,
                    height: height*.05,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Message ${chef.name}', 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      );

    showDialog(context: context, builder : (BuildContext context) => chefPopup);
  }

  Widget title = Text('Hello');
  Widget leading = Icon(Icons.search);

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
      return Scaffold(
        appBar: AppBar(
          title: Text('Hello ${user.firstName}', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black,), 
              onPressed: () => showSearch(context: context, delegate: SearchBar())
            )
          ],
        ),    
      );
    } else {
      return Scaffold(
        body: Center(child: Text('loading'))
      );
    }
  }
}
