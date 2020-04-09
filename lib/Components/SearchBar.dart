
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/MainScreens/ChefDetailsScreen.dart';
import 'package:omnus/Models/Chef.dart';

class SearchBar extends SearchDelegate<Chef>{

  final recentSearches = [];

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")
    ];
  }

  @override
  Widget buildLeading(BuildContext context){
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation), 
        onPressed: () => close(context, null)
    );
  }

  @override
  Widget buildResults(BuildContext context){
    List<Chef> results = [];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: FutureBuilder<QuerySnapshot>(
        future: SearchFunctions().getChefbyType(query),
        builder: (context,  snapshot) {
          if(snapshot.hasData){
            if(snapshot.data.documents.isEmpty){
              return Center(child: Text('No Results'));
            } else {
              List<Chef> temp = [];
              for (DocumentSnapshot snapshot in snapshot.data.documents) {
                temp.add(Chef.fromFirestore(snapshot));
              }
              results = temp;
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: .5)
                          )
                        ),
                      ),
                    );
                  },
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    Chef chef = results[index];

                    return Container(
                      child: ListTile(
                        onTap: () => Navigator.push(context, 
                          MaterialPageRoute(builder: (BuildContext context) => ChefDetailsScreen(chef: chef))
                        ),
                        leading: Container(
                          //color: Colors.amber,
                          width: 55,
                          height: double.infinity,
                          alignment: Alignment.topCenter,
                          child: GFAvatar(
                            shape: GFAvatarShape.standard,
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                        title: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
              chef.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
                              )
                            ),
                            Padding(padding: EdgeInsets.all(1)),
                            Row(
                              children: <Widget>[
              Text(chef.type == 'both' ? 'Chef & Prep' : (chef.type == 'chef' ? 'Chef' : 'Prep'),
                style: TextStyle(fontSize: 18),),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 4.0, 0),
                child: Text('${chef.rating}',
                  style: TextStyle(color: Colors.amber, fontSize: 18),),
              ),
              GFRating(
                allowHalfRating: true,
                value: chef.rating,
                size: 23,
                color: Colors.amber,
                borderColor: Colors.amber,
              )
                              ],
                            ),
              //               Padding(padding: EdgeInsets.all(1)),
              //               Container(
              //                 alignment: Alignment.centerRight,
              //                 child: Text('\$${chef.rate}',
              // style: TextStyle(
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold
              // ),
              //                 ),
              //               ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          } else {
            return Center(child: Text('Loading'));
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context){
        
    List<Chef> results = [];
    if(query == ""){
      return ListView.builder(
        itemCount: recentSearches.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recentSearches[index].name ?? 'No results'),
          );
        });
    } else{
    return FutureBuilder<QuerySnapshot>(
      future: SearchFunctions().getChefbyType(query),
      builder: (context,  snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.documents.isEmpty){
            return Center(child: Text('No Results'));
          } else {
            List<Chef> temp = [];
            for (DocumentSnapshot snapshot in snapshot.data.documents) {
              temp.add(Chef.fromFirestore(snapshot));
            }
            results = temp;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.push(context, 
                    MaterialPageRoute(builder: (BuildContext context) => ChefDetailsScreen(chef: results[index]))
                  ),
                  title: Text(results[index].name),
                );
              });
          }
        } else {
          return Center(child: Text('Loading'));
        }
      },
    );
    }
  }
   
}