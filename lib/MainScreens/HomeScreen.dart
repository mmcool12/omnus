import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/MainScreens/LoadingScreen.dart';
//import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/MainScreens/OverviewScreen.dart';
import 'package:omnus/MainScreens/SettingsScreen.dart';
import 'package:omnus/MainScreens/CardsScreen.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
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

  Widget title = Text('Hello');
  Widget leading = Icon(Icons.search);

  toggleSearch(firstName){
    
    setState(() {

      if(searching){
        title = SearchBar<Chef>(
                onSearch: getChefs,
                onItemFound: (Chef chef, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(chef.name),
                    ),
                  );
                },
                searchBarStyle:
                    SearchBarStyle(backgroundColor: Colors.lightGreen),
              );
        leading = Icon(Icons.close);
      } else{
        title = Text('Hello, $firstName');
        leading = Icon(Icons.search);
      }
    });
  }

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
          title: Text('Hello ${user.firstName}')
        ),
        body: SearchBar<Chef>(
        onSearch: getChefs,
        onItemFound: (Chef chef, int index) {
          return Card(
            child: ListTile(
              title: Text(chef.name),
            ),
          );
        },
        searchBarStyle:
            SearchBarStyle(backgroundColor: Colors.lightGreen),
                  ),
              
      );
    } else {
      return Scaffold(
        body: Center(child: Text('loading'))
      );
    }
  }
}
